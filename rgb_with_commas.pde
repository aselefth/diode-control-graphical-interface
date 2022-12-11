import processing.serial.*;

Serial port;
                                           //define a serial port variable
                                           //переменная последовательного подключения
int h = 0;                                
int s = 0;                                 //define a HSB variables - h(hue), s(saturation), br(brightness)
int br = 360;                              //переменные в представлении HSB

int r = 0;                                //define rgb color representation varaibles. They store color, that was refactored from hsb color mode
int g = 0;                                //переменные в представлении RGB для дальнейшего вывода в Arduino IDE
int b = 0;

color bg = color(207, 185, 151);          //background color and color that we get after all the calculations
color col = color(0, 0, 0);               //цвет фона и наш конечный цвет


void setup() {                            //setting up window's size, background and assigning port used to connect arduino
  size(470, 510);                         //задаем размер окна, задний фон и переопределяем порт
  background(bg);
  port = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  
  stroke(0);                              //draw a rectangle that is going to be a border for color picker
  fill(255);                              //строим квадрат-рамку для цвето-пикера
  rect(14, 14, 361, 361);
  
  colorMode(HSB, 360, 360, 360);          //draw a color picker. color mode is HSB, where we set a maximum valiues for hue, saturation and brightness
  for (int i = 0; i < 360; i++) {         //строим цвето-пикер, задаем диапазон для всех параметров HSB
    for (int j = 0; j < 360; j++) {
      stroke(i, j, br);
      point(i + 15, j + 15);
    }
  }
  
  fill(0, 0, br);                        //draw a rectangle that is going to represent a brightness picker for color
  stroke(0);                             //строим прямоугольник для пикера яркости
  rect (395, 15, 60, 360);
  
  if (mousePressed && mouseX <= 375 && mouseY <= 375 && mouseX >= 15 && mouseY >= 15) {                //when mouse pressed, set hue and saturation as mouse coordinates
    h = mouseX - 15;                                                                                   //выставляем оттенок и насыщенность, когда мышка нажата
    s = mouseY - 15;
  }
  
  if (mousePressed && mouseX >=395 && mouseX <= 455 && mouseY >= 15 && mouseY <= 375) {                //same to brightness
    br = 375 - mouseY;                                                                                  
  }
  
  col = color(h, s, br);                                                                               //assign a color
  r = unhex(hex(col).substring(2, 4));                                                                 //set rgb color channels via hex-unhex convertation. 
  g = unhex(hex(col).substring(4, 6));                                                                 //конвертируем цвет из hsb в rgb и берем нужный канал
  b = unhex(hex(col).substring(6, 8));
  
  fill(h, s, br);                                                                                      //draw a rectangle with color
  rect (395, 395, 60, 100);                                                                            //прямоугольник с финальным цветом
  
  fill(bg);                                                                                            //draw a transparent rectangle so we can override text
  noStroke();                                                                                          //прозрачный прямоугольник для наложения на текст
  rect(10, 380, 150, 50);
  
  fill(0);                                                                                             //write color values on a canvas
  String s = "rgb: " + r + ';' + g + ';' + b;                                                          //выводим значения цвета на холст
  String s2 = "hex: #" + hex(col).substring(2, 8);
  textSize(18);
  text(s, 15, 395);
  text(s2, 15, 415);
  
  setRGB(r, g, b);
}

void setRGB(int r, int g, int b) {                                                                     //push values to arduino IDE
  port.write('S');                                                                                     //отправляем наши значения с начальным символом-флагом потока
  port.write(r);
  port.write(g);
  port.write(b);
}
