#!/usr/bin/env python3
"""
Generate placeholder pixel-art sprites for GNG.
Gothic palette: night blues, deep purples, dead browns, bone grays, red accents.
Output: 16x16 or 32x32 PNG spritesheets with idle/walk/jump frames.
"""
from PIL import Image
import os

OUT = os.path.join(os.path.dirname(__file__), "../game/assets/sprites")

# ── palette ───────────────────────────────────────────────────────────────────
T   = (0, 0, 0, 0)          # transparent
BLK = (10, 8, 12, 255)      # near-black outline
SKN = (200, 170, 130, 255)  # skin
HAR = (60,  40,  20, 255)   # dark hair / armor shadow
SIL = (80,  90, 110, 255)   # armor highlight (night blue-silver)
ARM = (50,  55,  70, 255)   # armor base
RED = (180, 30,  30, 255)   # accent red
GLD = (200, 160, 40, 255)   # gold trim
BRN = (80,  50,  20, 255)   # brown
GRN = (60, 130,  50, 255)   # green (zombie skin)
PRP = (80,  40, 100, 255)   # purple (demon)
BNE = (190, 180, 160, 255)  # bone / undead pale
DRK = (25,  20,  35, 255)   # dark bg fill
WNG = (140,  60,  20, 255)  # crow wing brown
ORG = (210, 100,  20, 255)  # red arremer orange-red

def img(w, h): return Image.new("RGBA", (w, h), T)

def put(im, pixels):
    """pixels: list of (x, y, color)"""
    px = im.load()
    for x, y, c in pixels:
        if 0 <= x < im.width and 0 <= y < im.height:
            px[x, y] = c

def sheet(frames, scale=2):
    w = frames[0].width
    h = frames[0].height
    out = Image.new("RGBA", (w * len(frames), h), T)
    for i, f in enumerate(frames):
        out.paste(f, (i * w, 0))
    if scale > 1:
        out = out.resize((out.width * scale, out.height * scale), Image.NEAREST)
    return out

# ── player (knight, 12x22 logical → 16x24 sprite canvas) ─────────────────────
def player_frame(leg_offset=0):
    im = img(12, 24)
    p = []
    # helmet
    for x in range(3, 9):
        p += [(x, 0, ARM), (x, 1, ARM)]
    p += [(3,2,ARM),(4,2,SIL),(5,2,SIL),(6,2,SIL),(7,2,SIL),(8,2,ARM)]
    # visor
    p += [(4,1,BLK),(5,1,BLK),(6,1,BLK),(7,1,BLK)]
    # face
    p += [(4,3,SKN),(5,3,SKN),(6,3,SKN),(7,3,SKN)]
    # body armor
    for y in range(4, 10):
        for x in range(3, 9):
            p.append((x, y, ARM))
    for x in range(4, 8):
        p += [(x, 4, SIL)]
    p += [(3,5,GLD),(8,5,GLD),(3,7,GLD),(8,7,GLD)]
    # arms
    p += [(2,5,ARM),(2,6,ARM),(2,7,ARM),(9,5,ARM),(9,6,ARM),(9,7,ARM)]
    p += [(1,8,GLD),(2,8,GLD),(9,8,GLD),(10,8,GLD)]  # gauntlets
    # lance (right side)
    p += [(10,3,GLD),(10,4,GLD),(10,5,BRN),(10,6,BRN),(10,7,BRN)]
    # legs
    leg_y = 10 + leg_offset
    for y in range(10, 16):
        p += [(4,y,ARM),(5,y,ARM),(6,y,ARM),(7,y,ARM)]
    # boots
    p += [(3,16,BLK),(4,16,ARM),(5,16,ARM),(6,16,ARM),(7,16,ARM),(8,16,BLK)]
    p += [(3,17,BLK),(4,17,ARM),(5,17,BNE),(6,17,BNE),(7,17,ARM),(8,17,BLK)]
    put(im, p)
    return im

def player_jump_frame():
    im = player_frame()
    px = im.load()
    # shift legs up slightly
    for y in range(17, 13, -1):
        for x in range(3, 9):
            px[x, y] = px[x, y-2]
    return im

frames_player = [player_frame(0), player_frame(1), player_frame(0), player_frame(-1)]
frames_jump   = [player_jump_frame()]
s = sheet(frames_player)
s.save(os.path.join(OUT, "player/player_walk.png"))
sheet(frames_jump).save(os.path.join(OUT, "player/player_jump.png"))
sheet([player_frame(0)]).save(os.path.join(OUT, "player/player_idle.png"))
print("✓ player")

# ── zombie (12x20) ────────────────────────────────────────────────────────────
def zombie_frame(arm_up=False):
    im = img(12, 22)
    p = []
    # head
    for x in range(3, 9):
        for y in range(0, 5):
            p.append((x, y, BNE))
    p += [(3,0,GRN),(8,0,GRN),(3,4,GRN),(8,4,GRN)]
    # eyes (red glow)
    p += [(4,2,RED),(7,2,RED)]
    # jaw
    p += [(4,4,BLK),(5,4,BNE),(6,4,BNE),(7,4,BLK)]
    # tattered body
    for y in range(5, 13):
        for x in range(3, 9):
            p.append((x, y, GRN))
    p += [(3,6,BNE),(8,6,BNE),(3,9,BNE),(8,9,BNE)]
    # arms outstretched
    ay = 7 if arm_up else 8
    p += [(0,ay,BNE),(1,ay,BNE),(2,ay,BNE),(9,ay,BNE),(10,ay,BNE),(11,ay,BNE)]
    p += [(0,ay+1,GRN),(1,ay+1,GRN),(9,ay+1,GRN),(10,ay+1,GRN)]
    # legs
    for y in range(13, 20):
        p += [(4,y,BRN),(5,y,BRN),(6,y,BRN),(7,y,BRN)]
    p += [(3,20,BLK),(4,20,BRN),(7,20,BRN),(8,20,BLK)]
    put(im, p)
    return im

sheet([zombie_frame(False), zombie_frame(True), zombie_frame(False), zombie_frame(True)]).save(
    os.path.join(OUT, "enemies/zombie_walk.png"))
print("✓ zombie")

# ── crow (14x12) ──────────────────────────────────────────────────────────────
def crow_frame(wing_up=False):
    im = img(16, 12)
    p = []
    # body
    for x in range(5, 11):
        for y in range(3, 9):
            p.append((x, y, BLK))
    p += [(6,3,WNG),(7,3,WNG),(8,3,WNG),(9,3,WNG)]
    # beak
    p += [(4,5,ORG),(3,5,ORG)]
    # eye
    p += [(9,5,RED)]
    # wings
    if wing_up:
        for x in range(0, 5):   p.append((x, 2, BLK))
        for x in range(11, 16): p.append((x, 2, BLK))
        for x in range(1, 5):   p.append((x, 1, WNG))
        for x in range(11, 15): p.append((x, 1, WNG))
    else:
        for x in range(0, 5):   p.append((x, 5, BLK))
        for x in range(11, 16): p.append((x, 5, BLK))
        for x in range(1, 5):   p.append((x, 6, WNG))
        for x in range(11, 15): p.append((x, 6, WNG))
    # tail
    p += [(10,8,BLK),(11,9,BLK),(12,10,BLK)]
    put(im, p)
    return im

sheet([crow_frame(True), crow_frame(False), crow_frame(True), crow_frame(False)]).save(
    os.path.join(OUT, "enemies/crow_fly.png"))
print("✓ crow")

# ── demon knight (12x22) ──────────────────────────────────────────────────────
def dknight_frame(step=0):
    im = img(14, 24)
    p = []
    # helmet horns
    p += [(4,0,PRP),(9,0,PRP),(4,1,PRP),(9,1,PRP)]
    # head
    for x in range(4, 10):
        for y in range(1, 5):
            p.append((x, y, PRP))
    p += [(5,3,RED),(8,3,RED)]   # eyes
    # shield (left arm)
    for y in range(4, 12):
        p += [(0,y,ARM),(1,y,ARM),(2,y,SIL)]
    p += [(1,4,GLD),(1,5,GLD),(1,10,GLD),(1,11,GLD)]
    # body
    for y in range(4, 13):
        for x in range(4, 10):
            p.append((x, y, PRP))
    p += [(4,5,ARM),(5,5,ARM),(8,5,ARM),(9,5,ARM)]
    # spear (right arm)
    p += [(11,0,GLD),(11,1,GLD),(11,2,GLD),(11,3,BRN),(11,4,BRN),(11,5,BRN),
          (11,6,BRN),(11,7,BRN),(11,8,BRN),(11,9,BRN),(11,10,BRN)]
    p += [(12,0,GLD),(12,1,BLK)]
    # legs
    lx = 1 if step == 1 else 0
    for y in range(13, 21):
        p += [(4+lx, y, PRP),(5+lx,y,PRP),(6,y,PRP),(7,y,PRP),(8-lx,y,PRP),(9-lx,y,PRP)]
    p += [(4,21,BLK),(5,21,ARM),(6,21,ARM),(7,21,ARM),(8,21,ARM),(9,21,BLK)]
    put(im, p)
    return im

sheet([dknight_frame(0), dknight_frame(1), dknight_frame(0), dknight_frame(1)]).save(
    os.path.join(OUT, "enemies/demon_knight_walk.png"))
print("✓ demon knight")

# ── red arremer (14x16) ───────────────────────────────────────────────────────
def arremer_frame(wing_pos=0):
    im = img(16, 18)
    p = []
    # head / horns
    p += [(6,0,RED),(9,0,RED),(6,1,ORG),(7,1,ORG),(8,1,ORG),(9,1,ORG)]
    # face
    for x in range(5, 11):
        for y in range(1, 6):
            p.append((x, y, ORG))
    p += [(6,3,BLK),(9,3,BLK),(7,4,RED),(8,4,RED)]  # eyes + mouth
    # body
    for y in range(5, 12):
        for x in range(5, 11):
            p.append((x, y, RED))
    p += [(5,6,ORG),(10,6,ORG),(5,9,ORG),(10,9,ORG)]
    # wings
    if wing_pos == 0:
        for x in range(0, 5):   p += [(x,6,RED),(x,7,ORG)]
        for x in range(11, 16): p += [(x,6,RED),(x,7,ORG)]
    else:
        for x in range(0, 5):   p += [(x,4,RED),(x,3,ORG)]
        for x in range(11, 16): p += [(x,4,RED),(x,3,ORG)]
    # claws
    p += [(4,11,BLK),(5,12,ORG),(4,12,ORG),(11,11,BLK),(10,12,ORG),(11,12,ORG)]
    # legs
    p += [(6,12,RED),(7,12,RED),(8,12,RED),(9,12,RED)]
    p += [(5,13,RED),(6,14,ORG),(9,14,ORG),(10,13,RED)]
    put(im, p)
    return im

sheet([arremer_frame(0), arremer_frame(1), arremer_frame(0), arremer_frame(1)]).save(
    os.path.join(OUT, "enemies/red_arremer_fly.png"))
print("✓ red arremer")

# ── boss (28x44 logical → 32x48 sprite) ──────────────────────────────────────
def boss_frame(phase=1, anim=0):
    im = img(32, 48)
    p = []
    col = RED if phase == 2 else PRP
    # crown / horns
    for hx in [8, 15, 22]:
        p += [(hx, 0, col), (hx, 1, col), (hx, 2, col)]
    # head
    for x in range(8, 24):
        for y in range(2, 12):
            p.append((x, y, col))
    p += [(10,6,RED),(14,6,RED),(18,6,RED),(22,6,RED)]  # eyes (4 eyes for boss)
    p += [(11,9,BLK),(12,9,BLK),(13,9,BLK),(14,9,BLK),
          (17,9,BLK),(18,9,BLK),(19,9,BLK),(20,9,BLK)]  # teeth gaps
    # body
    for y in range(11, 32):
        for x in range(6, 26):
            p.append((x, y, col if (x+y)%3!=0 else ARM))
    p += [(6,12,GLD),(25,12,GLD),(6,20,GLD),(25,20,GLD),(6,28,GLD),(25,28,GLD)]
    # arms
    arm_y = 14 + (2 if anim else 0)
    for x in range(0, 6):
        p += [(x, arm_y, col), (x, arm_y+1, ARM), (x, arm_y+2, col)]
    for x in range(26, 32):
        p += [(x, arm_y, col), (x, arm_y+1, ARM), (x, arm_y+2, col)]
    p += [(0,arm_y+3,GLD),(1,arm_y+3,GLD),(2,arm_y+3,GLD)]
    p += [(29,arm_y+3,GLD),(30,arm_y+3,GLD),(31,arm_y+3,GLD)]
    # legs
    for y in range(32, 46):
        p += [(8,y,col),(9,y,col),(10,y,ARM),(11,y,ARM),
              (20,y,ARM),(21,y,ARM),(22,y,col),(23,y,col)]
    # feet
    p += [(7,46,BLK),(8,46,col),(11,46,col),(12,46,BLK)]
    p += [(19,46,BLK),(20,46,col),(23,46,col),(24,46,BLK)]
    put(im, p)
    return im

sheet([boss_frame(1,0), boss_frame(1,1)]).save(os.path.join(OUT, "boss/boss_p1.png"))
sheet([boss_frame(2,0), boss_frame(2,1)]).save(os.path.join(OUT, "boss/boss_p2.png"))
print("✓ boss")

# ── lance projectile (8x4) ────────────────────────────────────────────────────
lance = img(8, 4)
put(lance, [
    (0,1,GLD),(1,1,GLD),(2,2,GLD),(3,2,GLD),(4,1,GLD),(5,1,GLD),(6,0,GLD),(7,0,BLK),
    (0,2,BLK),(1,2,BLK),(6,1,BLK)
])
sheet([lance], scale=2).save(os.path.join(OUT, "weapons/lance.png"))
print("✓ lance")

# ── boss projectile (6x6 fireball) ───────────────────────────────────────────
fireball = img(8, 8)
put(fireball, [
    (3,0,ORG),(4,0,ORG),
    (2,1,ORG),(3,1,RED),(4,1,RED),(5,1,ORG),
    (1,2,ORG),(2,2,RED),(3,2,GLD),(4,2,GLD),(5,2,RED),(6,2,ORG),
    (1,3,ORG),(2,3,RED),(3,3,GLD),(4,3,GLD),(5,3,RED),(6,3,ORG),
    (2,4,ORG),(3,4,RED),(4,4,RED),(5,4,ORG),
    (3,5,ORG),(4,5,ORG),
])
sheet([fireball], scale=2).save(os.path.join(OUT, "weapons/fireball.png"))
print("✓ fireball")

# ── environment tiles (16x16) ─────────────────────────────────────────────────
def ground_tile():
    im = img(16, 16)
    p = []
    top_col  = (100, 80, 40, 255)
    dirt_col = (60,  45, 20, 255)
    stone_col= (70,  65, 55, 255)
    for x in range(16):
        p += [(x, 0, BLK), (x, 1, top_col), (x, 2, top_col)]
    for y in range(3, 16):
        for x in range(16):
            c = stone_col if (x + y) % 5 == 0 else dirt_col
            p.append((x, y, c))
    put(im, p)
    return im

def platform_tile():
    im = img(16, 8)
    p = []
    for x in range(16):
        p += [(x,0,BLK),(x,1,(110,90,50,255)),(x,2,(90,70,35,255))]
    for y in range(3, 8):
        for x in range(16):
            p.append((x, y, (50,40,20,255)))
    put(im, p)
    return im

ground_tile().resize((32,32), Image.NEAREST).save(os.path.join(OUT, "environment/ground_tile.png"))
platform_tile().resize((32,16), Image.NEAREST).save(os.path.join(OUT, "environment/platform_tile.png"))
print("✓ environment tiles")

print("\nAll sprites generated in game/assets/sprites/")
