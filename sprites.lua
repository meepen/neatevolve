local SPRITES = {
  [0x00] = { description = "Green Koopa Troopa without shell", deadly = true },
  [0x01] = { description = "Red Koopa Troopa without shell", deadly = true },
  [0x02] = { description = "Blue Koopa Troopa without shell", deadly = true },
  [0x03] = { description = "Yellow Koopa Troopa without shell", deadly = true },
  [0x04] = { description = "Green Koopa Troopa", deadly = true },
  [0x05] = { description = "Red Koopa Troopa", deadly = true },
  [0x06] = { description = "Blue Koopa Troopa", deadly = true },
  [0x07] = { description = "Yellow Koopa Troopa", deadly = true },
  [0x08] = { description = "Green Koopa Troopa flying left", deadly = true },
  [0x09] = { description = "Green Koopa Troopa bouncing", deadly = true },
  [0x0A] = { description = "Red Koopa Troopa flying vertically", deadly = true },
  [0x0B] = { description = "Red Koopa Troopa flying horizontally", deadly = true },
  [0x0C] = { description = "Yellow Koopa Troopa with wings", deadly = true },
  [0x0D] = { description = "Bob-Omb", deadly = true },
  [0x0E] = { description = "Keyhole", deadly = true },
  [0x0F] = { description = "Goomba", deadly = true },
  [0x10] = { description = "Bouncing Goomba with wings", deadly = true },
  [0x11] = { description = "Buzzy Beetle", deadly = true },
  [0x12] = { description = "Unused", deadly = false },
  [0x13] = { description = "Spiny", deadly = true },
  [0x14] = { description = "Spiny falling", deadly = true },
  [0x15] = { description = "Cheep Cheep swimming horizontally", deadly = true },
  [0x16] = { description = "Cheep Cheep swimming vertically", deadly = true },
  [0x17] = { description = "Cheep Cheep flying", deadly = true },
  [0x18] = { description = "Cheep Cheep jumping to surface", deadly = true },
  [0x19] = { description = "Display text from level message 1", deadly = false },
  [0x1A] = { description = "Classic Piranha Plant", deadly = true },
  [0x1B] = { description = "Bouncing Football in place", deadly = true },
  [0x1C] = { description = "Bullet Bill", deadly = true },
  [0x1D] = { description = "Hopping flame", deadly = true },
  [0x1E] = { description = "Lakitu", deadly = true },
  [0x1F] = { description = "Magikoopa", deadly = true },
  [0x20] = { description = "Magikoopa's magic", deadly = true },
  [0x21] = { description = "Moving coin", deadly = false },
  [0x22] = { description = "Green vertical net Koopa", deadly = true },
  [0x23] = { description = "Red vertical net Koopa", deadly = true },
  [0x24] = { description = "Green horizontal net Koopa", deadly = true },
  [0x25] = { description = "Red horizontal net Koopa", deadly = true },
  [0x26] = { description = "Thwomp", deadly = true },
  [0x27] = { description = "Thwimp", deadly = true },
  [0x28] = { description = "Big Boo", deadly = true },
  [0x29] = { description = "Koopa Kid", deadly = true },
  [0x2A] = { description = "Upside-down Piranha Plant", deadly = true },
  [0x2B] = { description = "Sumo Brother's lightning", deadly = true },
  [0x2C] = { description = "Yoshi egg", deadly = false },
  [0x2D] = { description = "Baby Yoshi", deadly = false },
  [0x2E] = { description = "Spike Top", deadly = true },
  [0x2F] = { description = "Portable springboard", deadly = false },
  [0x30] = { description = "Dry Bones that throws bones", deadly = true },
  [0x31] = { description = "Bony Beetle", deadly = true },
  [0x32] = { description = "Dry Bones that stays on ledges", deadly = true },
  [0x33] = { description = "Podoboo/vertical fireball", deadly = true },
  [0x34] = { description = "Boss fireball", deadly = true },
  [0x35] = { description = "Yoshi", deadly = false },
  [0x36] = { description = "Unused", deadly = false },
  [0x37] = { description = "Boo", deadly = true },
  [0x38] = { description = "Eerie that moves straight", deadly = true },
  [0x39] = { description = "Eerie that moves in a wave", deadly = true },
  [0x3A] = { description = "Urchin that moves a fixed distance", deadly = true },
  [0x3B] = { description = "Urchin that moves between walls", deadly = true },
  [0x3C] = { description = "Urchin that follows walls", deadly = true },
  [0x3D] = { description = "Rip Van Fish", deadly = true },
  [0x3E] = { description = "P-switch", deadly = false },
  [0x3F] = { description = "Para-Goomba", deadly = true },
  [0x40] = { description = "Para-Bomb", deadly = true },
  [0x41] = { description = "Dolphin that swims and jumps in one direction", deadly = false },
  [0x42] = { description = "Dolphin that swims and jumps back and forth", deadly = false },
  [0x43] = { description = "Dolphin that swims and jumps up and down", deadly = false },
  [0x44] = { description = "Torpedo Ted", deadly = true },
  [0x45] = { description = "Directional coins", deadly = false },
  [0x46] = { description = "Diggin' Chuck", deadly = true },
  [0x47] = { description = "Swimming/jumping fish", deadly = true },
  [0x48] = { description = "Diggin' Chuck's rock", deadly = true },
  [0x49] = { description = "Growing/shrinking pipe", deadly = false },
  [0x4A] = { description = "Goal Point Question Sphere", deadly = false },
  [0x4B] = { description = "Pipe-dwelling Lakitu", deadly = true },
  [0x4C] = { description = "Exploding block", deadly = false },
  [0x4D] = { description = "Monty Mole, ground-dwelling", deadly = true },
  [0x4E] = { description = "Monty Mole, ledge-dwelling", deadly = true },
  [0x4F] = { description = "Jumping Piranha Plant", deadly = true },
  [0x50] = { description = "Jumping Piranha Plant that spits fireballs", deadly = true },
  [0x51] = { description = "Ninji", deadly = true },
  [0x52] = { description = "Moving hole in ghost house ledge", deadly = true },
  [0x53] = { description = "Throw block sprite", deadly = false },
  [0x54] = { description = "Revolving door for climbing net", deadly = false },
  [0x55] = { description = "Checkerboard platform, horizontal", deadly = false },
  [0x56] = { description = "Flying rock platform, horizontal", deadly = false },
  [0x57] = { description = "Checkerboard platform, vertical", deadly = false },
  [0x58] = { description = "Flying rock platform, vertical", deadly = false },
  [0x59] = { description = "Turn block bridge, horizontal and vertical", deadly = false },
  [0x5A] = { description = "Turn block bridge, horizontal", deadly = false },
  [0x5B] = { description = "Floating brown platform", deadly = false },
  [0x5C] = { description = "Floating checkerboard platform", deadly = false },
  [0x5D] = { description = "Small orange floating platform", deadly = false },
  [0x5E] = { description = "Large orange floating platform", deadly = false },
  [0x5F] = { description = "Swinging brown platform", deadly = false },
  [0x60] = { description = "Flat switch palace switch", deadly = false },
  [0x61] = { description = "Floating skulls", deadly = false },
  [0x62] = { description = "Brown line-guided platform", deadly = false },
  [0x63] = { description = "Brown/checkered line-guided platform", deadly = false },
  [0x64] = { description = "Line-guided rope mechanism", deadly = false },
  [0x65] = { description = "Chainsaw (line-guided)", deadly = true },
  [0x66] = { description = "Upside-down chainsaw (line-guided)", deadly = true },
  [0x67] = { description = "Grinder, line-guided", deadly = true },
  [0x68] = { description = "Fuzzy, line-guided", deadly = true },
  [0x69] = { description = "Unused", deadly = false },
  [0x6A] = { description = "Coin game cloud", deadly = false },
  [0x6B] = { description = "Wall springboard (left wall)", deadly = false },
  [0x6C] = { description = "Wall springboard (right wall)", deadly = false },
  [0x6D] = { description = "Invisible solid block", deadly = false },
  [0x6E] = { description = "Dino-Rhino", deadly = true },
  [0x6F] = { description = "Dino-Torch", deadly = true },
  [0x70] = { description = "Pokey", deadly = true },
  [0x71] = { description = "Super Koopa with red cape", deadly = true },
  [0x72] = { description = "Super Koopa with yellow cape", deadly = true },
  [0x73] = { description = "Super Koopa on the ground", deadly = true },
  [0x74] = { description = "Mushroom", deadly = false },
  [0x75] = { description = "Flower", deadly = false },
  [0x76] = { description = "Star", deadly = false },
  [0x77] = { description = "Feather", deadly = false },
  [0x78] = { description = "1-Up mushroom", deadly = false },
  [0x79] = { description = "Growing vine", deadly = false },
  [0x7A] = { description = "Firework", deadly = false },
  [0x7B] = { description = "Goal tape", deadly = false },
  [0x7C] = { description = "Peach (after Bowser fight)", deadly = false },
  [0x7D] = { description = "P-Balloon", deadly = false },
  [0x7E] = { description = "Flying red coin", deadly = false },
  [0x7F] = { description = "Flying golden mushroom", deadly = false },
  [0x80] = { description = "Key", deadly = false },
  [0x81] = { description = "Changing item", deadly = false },
  [0x82] = { description = "Bonus game sprite", deadly = false },
  [0x83] = { description = "Flying question block that flies left", deadly = false },
  [0x84] = { description = "Flying question block that flies back and forth", deadly = false },
  [0x85] = { description = "Unused", deadly = false },
  [0x86] = { description = "Wiggler", deadly = true },
  [0x87] = { description = "Lakitu's cloud", deadly = false },
  [0x88] = { description = "Winged cage (unused)", deadly = false },
  [0x89] = { description = "Layer 3 Smash", deadly = false },
  [0x8A] = { description = "Yoshi's House bird", deadly = false },
  [0x8B] = { description = "Puff of smoke from Yoshi's House", deadly = false },
  [0x8C] = { description = "Side exit enabler", deadly = false },
  [0x8D] = { description = "Ghost house exit sign and door", deadly = false },
  [0x8E] = { description = "Invisible warp hole", deadly = false },
  [0x8F] = { description = "Scale platforms", deadly = false },
  [0x90] = { description = "Large green gas bubble", deadly = true },
  [0x91] = { description = "Chargin' Chuck", deadly = true },
  [0x92] = { description = "Splittin' Chuck", deadly = true },
  [0x93] = { description = "Bouncin' Chuck", deadly = true },
  [0x94] = { description = "Whistlin' Chuck", deadly = true },
  [0x95] = { description = "Chargin' Chuck", deadly = true },
  [0x96] = { description = "Unused", deadly = false },
  [0x97] = { description = "Puntin' Chuck", deadly = true },
  [0x98] = { description = "Pitchin' Chuck", deadly = true },
  [0x99] = { description = "Volcano Lotus", deadly = true },
  [0x9A] = { description = "Sumo Brother", deadly = true },
  [0x9B] = { description = "Amazing Flying Hammer Brother", deadly = true },
  [0x9C] = { description = "Flying gray blocks for Hammer Brother", deadly = false },
  [0x9D] = { description = "Sprite in a bubble", deadly = false },
  [0x9E] = { description = "Ball 'n' Chain", deadly = true },
  [0x9F] = { description = "Banzai Bill", deadly = true },
  [0xA0] = { description = "Bowser battle activator", deadly = false },
  [0xA1] = { description = "Bowser's bowling ball", deadly = true },
  [0xA2] = { description = "Mecha-Koopa", deadly = true },
  [0xA3] = { description = "Rotating gray platform", deadly = false },
  [0xA4] = { description = "Floating spike ball", deadly = true },
  [0xA5] = { description = "Wall-following Sparky/Fuzzy", deadly = true },
  [0xA6] = { description = "Hothead", deadly = true },
  [0xA7] = { description = "Iggy's ball projectile", deadly = true },
  [0xA8] = { description = "Blargg", deadly = true },
  [0xA9] = { description = "Reznor", deadly = true },
  [0xAA] = { description = "Fishbone", deadly = true },
  [0xAB] = { description = "Rex", deadly = true },
  [0xAC] = { description = "Wooden spike pointing down", deadly = true },
  [0xAD] = { description = "Wooden spike pointing up", deadly = true },
  [0xAE] = { description = "Fishin' Boo", deadly = true },
  [0xAF] = { description = "Boo Block", deadly = true },
  [0xB0] = { description = "Reflecting stream of Boo Buddies", deadly = true },
  [0xB1] = { description = "Creating/eating block", deadly = true },
  [0xB2] = { description = "Falling spike", deadly = true },
  [0xB3] = { description = "Bowser statue fireball", deadly = true },
  [0xB4] = { description = "Grinder that moves on the ground", deadly = true },
  [0xB5] = { description = "Unused", deadly = false },
  [0xB6] = { description = "Reflecting fireball", deadly = true },
  [0xB7] = { description = "Carrot Top Lift, upper right", deadly = false },
  [0xB8] = { description = "Carrot Top Lift, upper left", deadly = false },
  [0xB9] = { description = "Info Box", deadly = true },
  [0xBA] = { description = "Timed Lift", deadly = false },
  [0xBB] = { description = "Moving castle block", deadly = false },
  [0xBC] = { description = "Bowser statue", deadly = false },
  [0xBD] = { description = "Sliding Koopa", deadly = true },
  [0xBE] = { description = "Swooper", deadly = true },
  [0xBF] = { description = "Mega Mole", deadly = true },
  [0xC0] = { description = "Sinking gray platform on lava", deadly = false },
  [0xC1] = { description = "Flying gray turn blocks", deadly = false },
  [0xC2] = { description = "Blurp", deadly = true },
  [0xC3] = { description = "Porcu-Puffer", deadly = true },
  [0xC4] = { description = "Gray platform that falls", deadly = false },
  [0xC5] = { description = "Big Boo Boss", deadly = true },
  [0xC6] = { description = "Spotlight/dark room sprite", deadly = false },
  [0xC7] = { description = "Invisible mushroom", deadly = false },
  [0xC8] = { description = "Light switch for dark room", deadly = false },
  [0xC9] = { description = "Bullet Bill shooter", deadly = true },
  [0xCA] = { description = "Torpedo Ted launcher", deadly = true },
  [0xCB] = { description = "Eerie generator", deadly = false },
  [0xCC] = { description = "Para-Goomba generator", deadly = false },
  [0xCD] = { description = "Para-Bomb generator", deadly = false },
  [0xCE] = { description = "Para-Goomba and Para-Bomb generator", deadly = false },
  [0xCF] = { description = "Dolphin generator (left)", deadly = false },
  [0xD0] = { description = "Dolphin generator (right)", deadly = false },
  [0xD1] = { description = "Flying fish generator", deadly = false },
  [0xD2] = { description = "Turn Off Generator 2", deadly = false },
  [0xD3] = { description = "Super Koopa generator", deadly = false },
  [0xD4] = { description = "Bubbled sprite generator", deadly = false },
  [0xD5] = { description = "Bullet Bill generator", deadly = false },
  [0xD6] = { description = "Multidirectional Bullet Bill generator", deadly = false },
  [0xD7] = { description = "Multidirectional diagonal Bullet Bill generator", deadly = false },
  [0xD8] = { description = "Bowser statue fire generator", deadly = false },
  [0xD9] = { description = "Turn Off Generators", deadly = false },
  [0xDA] = { description = "Green Koopa shell", deadly = false },
  [0xDB] = { description = "Red Koopa shell", deadly = false },
  [0xDC] = { description = "Blue Koopa shell", deadly = false },
  [0xDD] = { description = "Yellow Koopa shell", deadly = false },
  [0xDE] = { description = "Group of 5 wave-moving Eeries", deadly = true },
  [0xDF] = { description = "Green Para-Koopa shell", deadly = false },
  [0xE0] = { description = "3 rotating gray platforms", deadly = false },
  [0xE1] = { description = "Boo Ceiling", deadly = true },
  [0xE2] = { description = "Boo Ring moving counterclockwise", deadly = true },
  [0xE3] = { description = "Boo Ring moving clockwise", deadly = true },
  [0xE4] = { description = "Swooper Death Bat Ceiling", deadly = true },
  [0xE5] = { description = "Appearing/disappearing Boos", deadly = true },
  [0xE6] = { description = "Background candle flames", deadly = false },
  [0xE7] = { description = "Unused", deadly = false },
  [0xE8] = { description = "Special auto-scroll command", deadly = false },
  [0xE9] = { description = "Layer 2 Smash", deadly = false },
  [0xEA] = { description = "Layer 2 scrolling command", deadly = false },
  [0xEB] = { description = "Unused", deadly = false },
  [0xEC] = { description = "Unused", deadly = false },
  [0xED] = { description = "Layer 2 Falls", deadly = false },
  [0xEE] = { description = "Unused", deadly = false },
  [0xEF] = { description = "Layer 2 sideways-scrolling command", deadly = false },
  [0xF0] = { description = "Unused", deadly = false },
  [0xF1] = { description = "Unused", deadly = false },
  [0xF2] = { description = "Layer 2 on/off switch controller", deadly = false },
  [0xF3] = { description = "Standard auto-scroll command", deadly = false },
  [0xF4] = { description = "Fast background scroll", deadly = false },
  [0xF5] = { description = "Layer 2 sink command", deadly = false },
  [0xF6] = { description = "Unused", deadly = false },
  [0xF7] = { description = "Unused", deadly = false },
  [0xF8] = { description = "Unused", deadly = false },
  [0xF9] = { description = "Unused", deadly = false },
  [0xFA] = { description = "Unused", deadly = false },
  [0xFB] = { description = "Unused", deadly = false },
  [0xFC] = { description = "Unused", deadly = false },
  [0xFD] = { description = "Unused", deadly = false },
  [0xFE] = { description = "Unused", deadly = false },
  [0xFF] = { description = "Unused", deadly = false }
}

return SPRITES