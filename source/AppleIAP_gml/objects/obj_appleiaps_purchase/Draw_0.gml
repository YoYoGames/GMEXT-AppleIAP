
event_inherited();

draw_set_font(Font_YoYo_15)
draw_set_valign(fa_left)
draw_set_halign(fa_left)

draw_text(bbox_left+10,bbox_top-90,"Title: " + localizedTitle)
if(string_length(localizedDesc) < 15)
	draw_text(bbox_left+10,bbox_top-60,"Description: " + localizedDesc)
else
	draw_text(bbox_left+10,bbox_top-60,"Description: " + string_copy(localizedDesc,1,12) + "...")
draw_text(bbox_left+10,bbox_top-30,"Price: " + string(price) + currencyCode + currencySymbol)
