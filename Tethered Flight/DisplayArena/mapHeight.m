function hout = mapHeight(hin, arena)

hout = arena.offset + (hin - 1).^ arena.zoom /(8*arena.numHPanels)^(arena.zoom - 1);