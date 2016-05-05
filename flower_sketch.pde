/*----------------------------------
     
 Copyright by Diana Lange 2015
 Don't use without any permission. Creative Commons: Attribution Non-Commercial.
     
 mail: kontakt@diana-lange.de
 web: diana-lange.de
 facebook: https://www.facebook.com/DianaLangeDesign
 flickr: http://www.flickr.com/photos/dianalange/collections/
 tumblr: http://dianalange.tumblr.com/
 twitter: http://twitter.com/DianaOnTheRoad
 vimeo: https://vimeo.com/dianalange/videos
 */
Flower f;
 
boolean beSmooth = true;
 
void setup ()
{
  size(700, 700);
  smooth();
  //noLoop();
  //hint(DISABLE_DEPTH_TEST);
  noLoop();
  background (247);
  f = new Flower (200, width/2, height/2, 280, 0, 0.75);
}
 
void draw ()
{
  background(241,231,236);
 // stroke(211, 196, 154, 120);
  noStroke();
  fill(247);
  ellipse (width/2, height/2, 580, 580);
  
   
  noFill();
  strokeWeight(0.5);
  stroke (#111111);
  f.display();
   
   
   
}
 
class Anchor
{
  private float angle, minAngle, maxAngle, length;
  private int centerX, centerY;
  private ArrayList branches;
 
  Anchor (float angle, float minAngle, float maxAngle, float length, int centerX, int centerY, float minNext )
  {
    this.angle = angle;
    this.minAngle = minAngle; 
    this.maxAngle = maxAngle;
    this.length = length;
    this.centerX = centerX;
    this.centerY = centerY;
    branches = new ArrayList();
    createBranches(angle, centerX, centerY, 0, random (length /15.0, length /2.0), 0, minNext);
  }
 
  public int getCenterX ()
  {
    return centerX;
  }
 
  public int getCenterY ()
  {
    return centerY;
  }
 
  private void createBranches (float fAngle, float startX, float startY, float totalLength, float flength, int count, float minNext)
  {
    float mangle = random (-minAngle/2, maxAngle/2);
    float weighing = random (0.25, 0.75);
 
 
    //----- start and end points to be drawn plus an in-between point
    float [] [] points = new float [5] [2];
    if (flength>80) points = new float [6] [2];
    points [0] [0] = points [1] [0] = startX;                                                                                                                  // startpunkt x
    points [0] [1] = points [1] [1] = startY;                                                                                                                  // startpunkt y
    points [points.length-2] [0] = points [points.length-1] [0] = startX + cos (radians (fAngle)) * flength;                                                   // endpunkt x
    points [points.length-2] [1] = points [points.length-1] [1] = startY + sin (radians (fAngle)) * flength;                                                   // endpunkt y
    if (flength<=80)
    {
      points [2] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
      points [2] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
    }
    else {
      weighing = random (0.25, 0.5);
      points [2] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
      points [2] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
      mangle = random (-minAngle/2, maxAngle/2);
      weighing = random (0.5, 0.75);
      points [3] [0] = startX + cos (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrollpunkt x
      points [3] [1] = startY + sin (radians (fAngle+mangle)) * dist (startX, startY, points [points.length-1] [0], points [points.length-1] [1]) * weighing;  // kontrolltpunkt y
    }
 
    //----- add new branch
    branches.add (new Branch (points));
 
    //----- calculte current branch length
    totalLength+= flength;
 
    //----- recursion
    if (count < 25 && flength > 1.5)
    {
      count++;
      int dir = (int) random (0, 3);
 
      //----- on or two anchors
      if (dir <= 1)
      {
        float nextflength = flength * random (0.75, 1.20);
        if ( totalLength+nextflength < length) createBranches (fAngle + random (minAngle*2, maxAngle*2), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
      }
      else
      {
        float nextflength = flength * random (minNext, 1.05);
        if ( totalLength+nextflength < length) createBranches (fAngle + random (minAngle/2, 0), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
        nextflength = flength * random (minNext, 1.05);
        if ( totalLength+nextflength < length) createBranches (fAngle + random (0, maxAngle/2), points [points.length-1] [0], points [points.length-1] [1], totalLength, nextflength, count, minNext);
      }
    }
  }
 
  public void display ()
  {
    Branch br;
    for (int i = 0; i < branches.size(); i++)
    {
      br = (Branch) branches.get (i);
      br.display();
    }
  }
}
 
 
class Branch
{
  private float [] [] points;
 
  Branch (float [] [] points)
  {
    this.points = new float [points.length] [points[0].length];
    arrayCopy (points, this.points);
  }
 
  public void display ()
  {
     
    beginShape();
    for (int i = 0; i < points.length; i++)
    {
      curveVertex (points [i] [0], points [i] [1]);
    }
    endShape();
  }
}
 
class Flower
{
  private Anchor [] anchor;
  private int d;
  private int mode;
  private float minNext;
 
  Flower (int num, int centerX, int centerY, int d, int mode, float minNext)
  {
    this.minNext = minNext;
    this.d = d;
    this.mode = mode;
    createAnchors (num, centerX, centerY, d);
  }
   
  
  public void less ()
  {
    int num = anchor.length;
    num-= 10;
    if (num < 50) num = 50;
    minNext = map (mouseY, 0, height, 0.2, 0.8);
    createAnchors (num, anchor[0].getCenterX(), anchor[0].getCenterY(), d);
  }
   
  public void more ()
  {
    int num = anchor.length;
    num+= 10;
    if (num > 900) num = 900;
    minNext = map (mouseY, 0, height, 0.2, 0.8);
    createAnchors (num, anchor[0].getCenterX(), anchor[0].getCenterY(), d);
  }
 
  public void newFlower ()
  {
    minNext = map (mouseY, 0, height, 0.2, 0.8);
    createAnchors (anchor.length, anchor[0].getCenterX(), anchor[0].getCenterY(), d);
  }
 
  public void toggleFlower ()
  {
    mode++;
    if (mode > 1) mode = 0;
    createAnchors (anchor.length, anchor[0].getCenterX(), anchor[0].getCenterY(), d);
  }   
 
  private void createAnchors(int num, int centerX, int centerY, int d)
  {
    float time = random (2);
    float timeVal = random (0.001, 0.5);
    anchor = new Anchor [num];
    float [] angles = new float [num];
 
    for (int i = 0; i < num; i++)
    {
      angles [i] = random (360);
    }
 
    arrayCopy (sort (angles), angles);
 
    float val = map (mouseY, 0, height, 4, 7);
    if (mouseX <= 0 || mouseX > width) val = 2;
    float minLength = d*10, maxLength = 0;
    float [] length = new float [num];
 
    for (int i = 0; i < length.length; i++)
    {
      length [i] = mode == 0 ? noise (time) * (float) d : d;
      if (length [i] < minLength) minLength = length [i];
      if (length [i] > maxLength) maxLength = length [i];
 
      time += timeVal;
    }
 
    if (minLength != maxLength)
    {
      for (int i = 0; i < length.length; i++)
      {
        length [i] = map (length [i], minLength, maxLength, minLength, d) ;
      }
    }
 
    for (int i = 0; i < num; i++)
    {
 
      anchor [i] = new Anchor (angles [i], -val, val, length [i], centerX, centerY, minNext);
    }
  }
 
 
  public void display ()
  {
    for (int i = 0; i < anchor.length; i++)
    {
      anchor[i].display();
    }
  }
}
 
void keyPressed ()
{
  if (key == 's') {
    beSmooth = !beSmooth;
    if (beSmooth) {
      smooth();
    } else {
      noSmooth();
    }
  }
 
  if (key == ' ') f.toggleFlower();
  redraw();
}
 
void mousePressed() {
  f.newFlower();
  redraw();
}