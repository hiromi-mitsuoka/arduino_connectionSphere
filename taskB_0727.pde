import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
int input0 = 0;
int input1 = 1;
int input2 = 2;
int num = 180;
float [] x = new float[num];
float [] y = new float[num];
float [] z = new float[num];
float [] r = new float[num];
int lightingCount = 0;
int lighting = 0;
float movement = 0;

void setup(){
  size(1000,700,P3D);
  arduino = new Arduino(this, Arduino.list()[11],57600);
  arduino.pinMode(input0,Arduino.INPUT);
  arduino.pinMode(input1,Arduino.INPUT);
  arduino.pinMode(input2,Arduino.INPUT);
  
  for(int i=0; i<num; i++){
    z[i] = random(-1,1);
    float angle = random(TWO_PI);
    x[i] = sqrt(1-z[i]*z[i])*cos(angle);
    y[i] = sqrt(1-z[i]*z[i])*sin(angle);
  }
}

void draw(){
  background(10);
  int analog0 = arduino.analogRead(input0);
  int analog1 = arduino.analogRead(input1);
  int analog2 = arduino.analogRead(input2);
  float distance = map(analog0,0,1024,400,50);
  float blightness = map(analog1,0,1000,0,num);
  float move = map(analog2,0,700,0,2);
  
  if(move>1){
    movement+=0.01;
  }
  translate(width/2,height/2);
  rotateY(frameCount*0.01);
  for(int i=0; i<num; i++){
    if(i%3 == 0){
      r[i] = 30+distance*abs(sin(movement));
    }
    if(i%3 == 1){
      r[i] = 30+distance*abs(sin(movement+PI/3));
    }
    if(i%3 == 2){
      r[i] = 30+distance*abs(sin(movement+TWO_PI/3));
    }
    //r[i]=100;
    stroke(240);
    strokeWeight(3);
    point(x[i]*r[i],y[i]*r[i],z[i]*r[i]);
    for(int k=0;k<blightness; k++){
      stroke(255-random(30),100+random(30),0);
      point(x[k]*r[k],y[k]*r[k],z[k]*r[k]);
    }
    //point(x[i]*r[i],y[i]*r[i],z[i]*r[i]);
  }
  
  for(int i=0; i<num; i++){
    for(int j=i+1; j<num; j++){
      float dist = dist(x[i]*r[i],y[i]*r[i],z[i]*r[i],
        x[j]*r[i],y[j]*r[i],z[j]*r[i]);
      if(dist < r[i]/2 && blightness==0){
        stroke(220,abs(100*sin(frameCount*0.01)));
        strokeWeight(0.5);
        line(x[i]*r[i],y[i]*r[i],z[i]*r[i],
          x[j]*r[i],y[j]*r[i],z[j]*r[i]);
      }
    }
  }
  
  for(int k=0;k<blightness; k++){
    for(int l=k+1; l<blightness;l++){
      float lightingDist = dist(x[k]*r[k],y[k]*r[k],z[k]*r[k],
        x[l]*r[l],y[l]*r[l],z[l]*r[l]);
      if(lightingDist < r[k]/2){        
        stroke(255-random(30),100+random(30),0);
        strokeWeight(1);
        line(x[k]*r[k],y[k]*r[k],z[k]*r[k],
        x[l]*r[l],y[l]*r[l],z[l]*r[l]);
      }
    }
  }
}

//i順に点灯していく
//センサーの値で大きさ変わる
//握られると震える
