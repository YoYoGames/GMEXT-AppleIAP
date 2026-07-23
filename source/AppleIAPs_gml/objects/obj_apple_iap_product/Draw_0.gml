
event_inherited();

draw_set_valign(fa_center)
draw_set_halign(fa_center)

draw_text(x, y - 180, data.id);
draw_text(x, y - 150, "type: " + string(data.type));
draw_text(x, y - 120, data.display_name);
draw_text(x, y - 90, data.display_price);
draw_text(x, y - 60, data.description);

//draw_text(x, y - 30, data.currency_code + " " + string(data.price));