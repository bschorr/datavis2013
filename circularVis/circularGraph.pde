void graph () {
  for (int j = 0; j < terms.length; j++){
  
  fill (colors[j]);
    
  beginShape ();
  
  for (int i = 0; i < data[j].length; i++) { 

  float var = map (data[j][i], 0, maxMap, 0, 750);
   
  float deg = map (i, 0, data[j].length, 0, 360);
  float angle = radians(deg);
  int radius = 0;
  xPos = cos (angle) * (radius+var);
  yPos = sin (angle) * (radius+var);
  
  vertex (xPos, yPos);
  
  if (i == 0) {
    
   firstXPos = xPos;
   firstYPos = yPos;
    
  }
   
 }
 
 vertex (firstXPos, firstYPos);
 endShape();
   }
  
}
