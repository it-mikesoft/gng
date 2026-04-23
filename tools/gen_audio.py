#!/usr/bin/env python3
"""
Generate placeholder SFX + music for GNG using pure Python stdlib.
Style: minor-key melodic, dry SFX — ADR-003.
"""
import wave, struct, math, os

RATE = 22050
OUT  = os.path.join(os.path.dirname(__file__), "../game/assets/audio")

def write_wav(path, samples, rate=RATE):
    samples_int = [max(-32768, min(32767, int(s * 32767))) for s in samples]
    with wave.open(path, "w") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(rate)
        f.writeframes(struct.pack(f"<{len(samples_int)}h", *samples_int))

def silence(dur): return [0.0] * int(RATE * dur)

def sine(freq, dur, amp=0.5, phase=0.0):
    n = int(RATE * dur)
    return [amp * math.sin(2 * math.pi * freq * i / RATE + phase) for i in range(n)]

def square(freq, dur, amp=0.3, duty=0.5):
    n = int(RATE * dur)
    p = RATE / freq
    return [amp if (i % p) / p < duty else -amp for i in range(n)]

def noise(dur, amp=0.2):
    import random
    return [amp * (random.random() * 2 - 1) for _ in range(int(RATE * dur))]

def mix(*tracks):
    length = max(len(t) for t in tracks)
    out = [0.0] * length
    for t in tracks:
        for i, s in enumerate(t):
            out[i] += s
    peak = max(abs(s) for s in out) or 1.0
    if peak > 0.95:
        out = [s / peak * 0.95 for s in out]
    return out

def env(samples, attack=0.005, decay=0.0, sustain=1.0, release=0.05):
    n  = len(samples)
    a  = int(attack  * RATE)
    d  = int(decay   * RATE)
    r  = int(release * RATE)
    out = list(samples)
    for i in range(n):
        if   i < a:               gain = i / a
        elif i < a + d:           gain = 1.0 - (i - a) / d * (1.0 - sustain)
        elif i < n - r:           gain = sustain
        else:                     gain = sustain * (n - i) / r
        out[i] *= gain
    return out

def slide(start_f, end_f, dur, amp=0.4):
    n = int(RATE * dur)
    return [amp * math.sin(2 * math.pi * (start_f + (end_f - start_f) * i / n) * i / RATE)
            for i in range(n)]

def cat(*parts): return [s for p in parts for s in p]

# ── SFX ──────────────────────────────────────────────────────────────────────

# jump — quick rising chirp
jump = env(slide(200, 600, 0.12, 0.5), attack=0.005, release=0.04)
write_wav(os.path.join(OUT, "sfx/jump.wav"), jump)
print("✓ jump")

# land — thud
land = env(mix(
    slide(150, 60, 0.08, 0.4),
    noise(0.06, 0.15)
), attack=0.002, release=0.06)
write_wav(os.path.join(OUT, "sfx/land.wav"), land)
print("✓ land")

# attack — lance throw (sharp blip)
attack = env(
    mix(square(440, 0.05, 0.3), sine(880, 0.05, 0.2)),
    attack=0.002, release=0.03)
write_wav(os.path.join(OUT, "sfx/attack.wav"), attack)
print("✓ attack")

# player_hit — impact + pain
player_hit = env(mix(
    slide(300, 100, 0.15, 0.4),
    noise(0.1, 0.25)
), attack=0.002, release=0.08)
write_wav(os.path.join(OUT, "sfx/player_hit.wav"), player_hit)
print("✓ player_hit")

# player_death — descending wail
death = env(
    slide(500, 60, 0.5, 0.5),
    attack=0.01, release=0.2)
write_wav(os.path.join(OUT, "sfx/player_death.wav"), death)
print("✓ player_death")

# enemy_die — pop + crunch
enemy_die = env(mix(
    slide(600, 80, 0.1, 0.3),
    noise(0.08, 0.2)
), attack=0.002, release=0.06)
write_wav(os.path.join(OUT, "sfx/enemy_die.wav"), enemy_die)
print("✓ enemy_die")

# boss_hit — heavy thud
boss_hit = env(mix(
    slide(200, 80, 0.2, 0.5),
    noise(0.15, 0.3),
    sine(120, 0.2, 0.3)
), attack=0.003, release=0.1)
write_wav(os.path.join(OUT, "sfx/boss_hit.wav"), boss_hit)
print("✓ boss_hit")

# checkpoint — ascending 3-note ding
def note(freq, dur, amp=0.4): return env(sine(freq, dur, amp), attack=0.01, release=0.05)
checkpoint = cat(note(523, 0.1), note(659, 0.1), note(784, 0.15))
write_wav(os.path.join(OUT, "sfx/checkpoint.wav"), checkpoint)
print("✓ checkpoint")

# game_over — low descending phrase
go_notes = [392, 330, 262, 220]
game_over_sfx = cat(*[note(f, 0.18, 0.4) for f in go_notes])
write_wav(os.path.join(OUT, "sfx/game_over.wav"), game_over_sfx)
print("✓ game_over")

# win — ascending fanfare
win_freqs = [523, 659, 784, 1047]
win_sfx = cat(*[note(f, 0.15, 0.45) for f in win_freqs]) + note(1047, 0.4, 0.5)
write_wav(os.path.join(OUT, "sfx/win.wav"), win_sfx)
print("✓ win")

# ── MUSIC ─────────────────────────────────────────────────────────────────────
# Minor pentatonic melody loop — A minor feel, gothic arcade
# Frequencies: A3=220, C4=262, D4=294, E4=330, G4=392, A4=440

def melody_note(freq, dur, amp=0.25):
    sq  = square(freq, dur, amp * 0.6, duty=0.45)
    si  = sine(freq * 2, dur, amp * 0.15)
    return env(mix(sq, si), attack=0.01, decay=0.05, sustain=0.7, release=0.04)

def bass_note(freq, dur, amp=0.35):
    return env(mix(
        square(freq, dur, amp, duty=0.5),
        sine(freq, dur, amp * 0.4)
    ), attack=0.005, decay=0.05, sustain=0.6, release=0.05)

# 4-bar level theme — 8 beats @ ~140 BPM → beat = 0.43s
beat = 60.0 / 140.0

def b(beats): return beat * beats

# Melody line (minor key A)
mel = cat(
    melody_note(440, b(1)),   # A4
    melody_note(330, b(0.5)), # E4
    melody_note(294, b(0.5)), # D4
    melody_note(262, b(1)),   # C4
    melody_note(220, b(1)),   # A3
    melody_note(294, b(0.5)), # D4
    melody_note(330, b(0.5)), # E4
    melody_note(392, b(1)),   # G4
    # bar 2
    melody_note(392, b(1)),
    melody_note(330, b(0.5)),
    melody_note(294, b(0.5)),
    melody_note(262, b(1)),
    melody_note(220, b(2)),
    # bar 3
    melody_note(262, b(0.5)),
    melody_note(294, b(0.5)),
    melody_note(330, b(1)),
    melody_note(440, b(0.5)),
    melody_note(392, b(0.5)),
    melody_note(330, b(1)),
    melody_note(294, b(1)),
    # bar 4
    melody_note(294, b(0.5)),
    melody_note(330, b(0.5)),
    melody_note(392, b(0.5)),
    melody_note(440, b(0.5)),
    melody_note(330, b(1)),
    melody_note(220, b(2)),
)

# Bass line (root + fifth)
def bass_bar(root, fifth):
    return cat(
        bass_note(root,  b(1)),
        bass_note(fifth, b(0.5)),
        bass_note(root,  b(0.5)),
        bass_note(fifth, b(1)),
        bass_note(root,  b(1)),
    )

bass = cat(
    bass_bar(110, 165),  # A2 + E3
    bass_bar(110, 165),
    bass_bar(98,  147),  # G2 + D3
    bass_bar(110, 165),
)

# Pad the shorter track with silence
def pad_to(t, length):
    return t + [0.0] * max(0, length - len(t))

length = max(len(mel), len(bass))
level_music = mix(pad_to(mel, length), pad_to(bass, length))
write_wav(os.path.join(OUT, "music/level_music.wav"), level_music)
print("✓ level_music")

# Boss music — faster, more frantic (160 BPM, shorter notes)
bb = 60.0 / 160.0

def bb_mel(beats): return bb * beats

boss_mel = cat(
    melody_note(523, bb_mel(0.5), 0.3),
    melody_note(440, bb_mel(0.5), 0.3),
    melody_note(392, bb_mel(0.5), 0.3),
    melody_note(330, bb_mel(0.5), 0.3),
    melody_note(262, bb_mel(1),   0.3),
    melody_note(294, bb_mel(0.5), 0.3),
    melody_note(330, bb_mel(0.5), 0.3),
    melody_note(392, bb_mel(1),   0.3),
    melody_note(440, bb_mel(0.5), 0.3),
    melody_note(523, bb_mel(0.5), 0.3),
    melody_note(659, bb_mel(1),   0.3),
    melody_note(523, bb_mel(1),   0.3),
    melody_note(440, bb_mel(2),   0.3),
)

boss_bass = cat(
    *[bass_note(110, bb_mel(0.5)) for _ in range(8)],
    *[bass_note(98,  bb_mel(0.5)) for _ in range(4)],
    *[bass_note(110, bb_mel(0.5)) for _ in range(4)],
)

blen     = max(len(boss_mel), len(boss_bass))
boss_music = mix(pad_to(boss_mel, blen), pad_to(boss_bass, blen))
write_wav(os.path.join(OUT, "music/boss_music.wav"), boss_music)
print("✓ boss_music")

print(f"\nAll audio generated in game/assets/audio/")
