import processing.video.*;
import gab.opencv.*;
import java.awt.*;
import oscP5.*;
import netP5.*;

int cont=0;
int cont2=0;
int x=0;

Capture cam;
OpenCV opencv;
OpenCV opencv1;
OscP5 oscP5;

ArrayList <Contour> losCountours;
NetAddress direccionRemota;

void setup(){
  String[] cameras = Capture.list();
  oscP5 = new OscP5(this, 12001);
  direccionRemota = new NetAddress("192.168.1.94", 12001);
  
  size(1280,720);
  opencv = new OpenCV(this,1280,720);
  opencv1 = new OpenCV(this,1280,720);
  
  cam = new Capture(this, cameras[11]);
  cam.start();
}

void draw(){
  
  
  if(cont<0){
    cont++;
  }else if(cont==150){
  
    cont--;
  }
  
  
  if(cam.available() == true){
    cam.read();
  }
  
  
 if(cam.width!= 0){
    
    opencv.loadImage(cam);
    opencv.threshold(this.x);
    
    opencv1.loadImage(cam);
    opencv1.threshold(this.x);
    
    losCountours = opencv.findContours();
    losCountours = opencv1.findContours();
    
  
    image(opencv1.getOutput(),0,0);
    tint(255,250,0,10);
    image(opencv.getOutput(),0,0);

    
    for(Contour c:losCountours){
      noFill();
      stroke(255,0,255);
      for(PVector p: c.getPolygonApproximation().getPoints()){
        vertex(p.x,p.y);
      }
      stroke(255,255,0);
      c.draw();
    }
  }
  //saveFrame("performance_########");
}


void oscEvent(OscMessage theOscMessage) {  
  if (theOscMessage.checkAddrPattern("/x") == true) {
    x = theOscMessage.get(0).intValue();
  }
}
