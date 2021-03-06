/*
  Author: Rishabh Asthana {asthana4@illinois.edu}
  File: Visual.pde
  Function: Controls the visualizations  
*/

 int allowChange = 1200;
 int visualizer = 0;
 int alpha = 255;
 int pAlpha = 255; 
 int pr = 0;
 int flip1 = 0;
 int flip2 = 0;

 void visual()
 {
   alpha = int(map(volAvg, 0 , maxVol, 0 , 255));
   if(alpha > pAlpha)
      pAlpha = alpha;
     
  // Particle link Visualizer
  if(visualizer == 0)
  {
      for(int i = 0; i < N; i++)
      {
         for(int j = 1; j < N; j++)
           particles.get(i).link(particles.get(j));      
         particles.get(i).run();
      }  
  }
   //Cirlcular Panel Visualizer
   else if(visualizer == 1)
   { 
    noStroke();
    pr = int(map(volAvg, 0 , maxVol, 0 , 600));
    pushMatrix();
        a += 2*0.098;
        c.display(map(volAvg, 0, maxVol, 0 ,60));
    popMatrix();
   
    if(pr> r)
        r = pr;
    r-=5;
   }
   
   //Sbar Visualizer
   else if(visualizer == 2)
   {
    stroke(channelColor[0]);
    float temp = map(mouseX, 0, boundW, 0, 5);
         a += 0.001;
         inR = int(map(volAvg, 0 , maxVol, 100 , 200));
          if(pnR < inR)
           pnR = inR;
           b.innerR = pnR;
           b.display();
           pnR--;
   }
   
   // Panel visualizer
   else if(visualizer == 3)
   { 
      pAlpha -= 10;
      noStroke();
      int h = panels[0].h/2;
      
      for(int i = 0; i < 11; i++)
      {
        float val = (map(fftAvgs[i], 0 , maxChannel[i], h , -h));
        panels12[i].display(val, channelColor[i]);
      } 
      
      float val = (map(fftAvgs[10], 0 , maxChannel[11], h , -h));
      panels12[11].display(val, channelColor[11]);
   }
   else if(visualizer == 4)
   {
    
    if(darkMode)
    {
    strokeWeight(1);
    stroke(channelColor[0],pAlpha  );//pAlpha - 155
    inR = int(map(volAvg, 0 , maxVol, 0 , 600));
    if(pnR < inR)
    pnR += int(map(volAvg, 0 , maxVol, 0 , 50));;
   
    core.rad = pnR;
    core.display(a); 
   
    a += 2*0.098;
    pnR-=5;
    if(pnR < 0) pnR = 0;
    pAlpha -= 10;
   }
   else visualizer = (int)random(11);
    
   }
   
   // Ring speaker visualizer
   else if(visualizer == 5)
   {
    t+=0.01;
    if(s < 0 || s > 1.0)
    flip *= -1;
    s += 0.001 * flip; 
   
    r1.display(map(fft3Avgs[0], 0 , max3Channel[0], 0 , 800), channelColor[0], map(fft3Avgs[0], 0 , max3Channel[0], 0 , 200));
    r2.display(map(fft3Avgs[1], 0 , max3Channel[1], 0 , 800), channelColor[1], map(fft3Avgs[1], 0 , max3Channel[1], 0 , 200));
    r3.display(map(fft3Avgs[2], 0 , max3Channel[2], 0 , 800), channelColor[2], map(fft3Avgs[2], 0 , max3Channel[2], 0 , 200));
    allowChange--;
   }
   
   // Ring sphere visualizer
   else if(visualizer == 6 )
   {
    stroke(channelColor[0], pAlpha);
    noFill();
    float scale = map(volAvg, 0 , maxVol, 1 , 1.1);
    rSphere2.display(scale, false, true, true);
    stroke(channelColor[1], pAlpha);
    rSphere3.display(scale + 4, false, true, true);

   }
   
   // Lorenz attractor visualizer
   else if(visualizer == 7)
   {
    strokeWeight(1);
    lorenz.display(); 
   }
   
   // Spring field visualizer
   else if(visualizer == 8)
   {
    blendMode(BLEND);
    pushMatrix();
      translate(-110,-100,-100);
      fill(0, 10);
      rect(0,0,2 * width, 2 * height);
    popMatrix();
    field.display();
   }
   
   // Lissajous curve visual
   else if(visualizer == 9)
   {
    blendMode(BLEND);
    pushMatrix();
      translate(-110,-100,-100);
      fill(0, 10);
      rect(0,0,2 * width, 2 * height);
    popMatrix();
    lissajous.display();
    pAlpha -= 10;
   }
   
   // Wireframe visualizer
   else if(visualizer == 10)
   {
    pushMatrix();
    stroke(channelColor[0], pAlpha);
      noFill();
      translate(boundW/2, boundH/2);
      rectMode(CENTER); 
      float sc = map(volAvg, 0 ,maxVol, 1 ,1.6);
      scale(sc);
   
      for(int i = 1; i < 100; i++)
      {
        if(flip2 == 0)  
            rotateZ(a);
        else if(flip2 == 1)  
            rotateY(a);
        else if(flip2 == 2)  
            rotateX(a);
        else 
        {
          rotateZ(a);
          rotateX(a);
        }
        
        if(flip1 == 0)
            rect(0, 0, 800 - (i * 8), 800- (i * 8));
        else  
            ellipse(0, 0, 800 - (i * 8), 800- (i * 8));
        
      
     }
     a += 0.01;
     pAlpha -= 10;
    popMatrix();
   }
   
   pAlpha--;
 }
 
 void initializeVisualizers()
 {
  particles = new ArrayList<Particle>();
  for(int i = 0; i < N; i++)
  particles.add(new Particle(int(random(width)), (int)random(height)));
  
  c = new cPanel(0, 0, boundW, boundH);
  
  b = new BarSpeaker(boundW/2, boundH/2, 100, 300);
  
  barSpeakers = new ArrayList<BarSpeaker>(); 
 
  barSpeakers.add(new BarSpeaker(int(boundW * 0.20), boundH/2, 100, 180));
  barSpeakers.add(new BarSpeaker(int(boundW * 0.50), boundH/2, 100, 180));
  barSpeakers.add(new BarSpeaker(int(boundW * 0.80), boundH/2, 100, 180));
  
  panels = new panel[3];
  panels[0] = new panel(int(boundW * 0.18) , boundH/2, boundW/3 - 9, boundH);
  panels[1] = new panel(int(boundW * 0.50) , boundH/2, boundW/3 - 9, boundH);
  panels[2] = new panel(int(boundW * 0.82) , boundH/2, boundW/3 - 9, boundH);
  
  panels12 = new panel[12];
  for(int i = 0; i < 12; i++)
  {
   panels12[i] = new panel((boundW/12 * i) + (boundW/12)/2  , boundH/2, boundW/12 +10 , boundH);
  }
  
  core = new Core(boundW/2, boundH/2);
  
  r1 = new RingSpeaker(int(0.15 * boundW), int(0.50 * boundH), 50);
  r2 = new RingSpeaker(int(0.50 * boundW), int(0.50 * boundH), 50);
  r3 = new RingSpeaker(int(0.85 * boundW), int(0.50 * boundH), 50);
  r4 = new RingSpeaker(int(0.50 * boundW), int(0.50 * boundH), 150);
  
  rSphere = new RingSphere(boundW/2, boundH/2, 300);
  rSphere2 = new RingSphere(boundW/2, boundH/2, 300);
  rSphere3 = new RingSphere(boundW/2, boundH/2, 300);
  rSphere4 = new RingSphere(boundW/2, boundH/2, 300);
  
  lorenz = new Attractor();
  
  field = new Field();
  
  lissajous = new Lissajous();
 
 }
