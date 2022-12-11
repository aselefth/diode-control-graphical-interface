#define R_PIN 11                                        //define pins for rgb              определяем пины для светодиода 
#define G_PIN 10
#define B_PIN 9

int r = 0;                                              //create a variables to store diode channels and for current data
int g = 0;                                              //объявляем переменные для хранения значений красного, 
int b = 0;                                              //синего и зеленого, а также для текущего потока данных
char currS;


void setup() {                                          //start serial connection and set pin modes for diode
  Serial.begin(9600);                                   //начинаем подключение и выставляем пины как выходы
  pinMode(R_PIN, OUTPUT);
  pinMode(G_PIN, OUTPUT);
  pinMode(B_PIN, OUTPUT);
}

void loop() {
  if (Serial.available()) {                             //check if we can get data from serial port         проверяем, можем ли получить данные с порта
    currS = Serial.read();                              //if it is, we get data from serial port            если можем, проверяем, являются ли они символом S
    if (currS == 'S') {                                 //S symbol means start of data stream               S - начало потока
      while (!Serial.available()) {}  
      r = Serial.read();                                //then consistently write data in every channel we defined before
      while (!Serial.available()) {}                    //затем последовательно считываем данные в переменные
      g = Serial.read();
      while (!Serial.available()) {}
      b = Serial.read();
      RGB(r, g, b);
    }
  }
  
}

void RGB(int r, int g, int b) {                         //function that sets the value for every diode channel
  analogWrite(R_PIN, 255 - r);                          //функция, устанавливающая состояние каналов диода
  analogWrite(G_PIN, 255 - g);
  analogWrite(B_PIN, 255 - b);
}