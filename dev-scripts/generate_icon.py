from PIL import Image, ImageDraw

def create_submarine_icon():
    size = (256, 256)
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Colors
    sub_color = (60, 70, 90, 255)       # Dark slate blue
    sub_dark_color = (40, 50, 70, 255)  # Darker for shading/back
    highlight_color = (80, 90, 110, 255) # Lighter for details
    window_color = (135, 206, 250, 255) # Light sky blue
    window_rim = (192, 192, 192, 255)   # Silver
    propeller_color = (218, 165, 32, 255) # Goldenrod
    periscope_color = (50, 50, 50, 255)

    cx, cy = 128, 128

    # Dimensions
    # Body is an oval
    body_w, body_h = 200, 90
    body_bbox = (cx - body_w//2, cy - body_h//2, cx + body_w//2, cy + body_h//2)
    
    # 1. Propeller (Left side) - Drawn first to be behind
    prop_center_x = cx - body_w//2 - 5
    prop_center_y = cy
    
    # Shaft
    draw.rectangle((prop_center_x, cy - 5, cx - body_w//2 + 20, cy + 5), fill=sub_dark_color)
    
    # Propeller Blades
    # Vertical oval
    draw.ellipse((prop_center_x - 8, cy - 35, prop_center_x + 8, cy + 35), fill=propeller_color)
    
    # 2. Tail Fins (Rudders)
    # Upper Fin
    draw.polygon([(cx - body_w//2 + 20, cy - 10), (cx - body_w//2 - 10, cy - 40), (cx - body_w//2 + 50, cy - 20)], fill=sub_dark_color)
    # Lower Fin
    draw.polygon([(cx - body_w//2 + 20, cy + 10), (cx - body_w//2 - 10, cy + 40), (cx - body_w//2 + 50, cy + 20)], fill=sub_dark_color)

    # 3. Conning Tower (Sail) - Top Center (Drawn before body? actually nicely fused if same color, but let's draw first so bottom is covered)
    tower_w, tower_h = 60, 45
    tower_x1 = cx - 15
    tower_y1 = cy - body_h//2 - tower_h + 15
    tower_x2 = cx + 45
    tower_y2 = cy
    
    # Periscope
    peri_w = 8
    peri_h = 35
    peri_x = tower_x1 + 20
    peri_y = tower_y1 - peri_h
    # Stem
    draw.rectangle((peri_x, peri_y, peri_x + peri_w, tower_y1), fill=periscope_color)
    # Scope view (Lens part)
    draw.rectangle((peri_x, peri_y, peri_x + 24, peri_y + 8), fill=periscope_color)
    # Lens glass
    draw.rectangle((peri_x + 22, peri_y + 1, peri_x + 24, peri_y + 7), fill=window_color)
    
    # Draw Tower Body
    # Using a rectangle with some rounding
    draw.rounded_rectangle((tower_x1, tower_y1, tower_x2, tower_y2), radius=10, fill=sub_color)

    # 4. Main Body
    draw.ellipse(body_bbox, fill=sub_color, outline=None)
    
    # Body Highlight (shine on top)
    draw.chord((cx - body_w//2 + 10, cy - body_h//2 + 5, cx + body_w//2 - 10, cy - body_h//2 + 25), start=180, end=360, fill=highlight_color)

    # 5. Front/Side Fins (Diving planes)
    fin_x = cx + 50
    fin_y = cy + 10
    draw.polygon([(fin_x, fin_y), (fin_x - 30, fin_y + 15), (fin_x + 10, fin_y + 15)], fill=sub_dark_color)

    # 6. Windows (Portholes)
    win_spacing = 45
    win_start_x = cx - 20
    radius = 13
    for i in range(3):
        wx = win_start_x + i * win_spacing
        wy = cy - 5 
        # Rim
        draw.ellipse((wx - radius - 3, wy - radius - 3, wx + radius + 3, wy + radius + 3), fill=window_rim)
        # Glass
        draw.ellipse((wx - radius, wy - radius, wx + radius, wy + radius), fill=window_color)
        # Reflection in glass
        draw.ellipse((wx - radius + 5, wy - radius + 5, wx - radius + 10, wy - radius + 10), fill=(255, 255, 255, 150))

    # Save
    icon_sizes = [(256, 256), (128, 128), (64, 64), (48, 48), (32, 32), (24, 24), (16, 16)]
    img.save('icon.ico', format='ICO', sizes=icon_sizes)
    print(f"Submarine icon.ico generated successfully with sizes: {icon_sizes}")
    
    # Save PNG for inspection
    img.save('icon.png', format='PNG')
    print("icon.png (256x256) saved for reference.")

if __name__ == "__main__":
    create_submarine_icon()
