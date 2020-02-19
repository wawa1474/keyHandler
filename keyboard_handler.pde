keyHandler handler;

void setup(){
  size(100,100);
  handler = new keyHandler(this);
  
  handler.addHotKey("a","SHIFT + A");
  handler.addHotKey("a","ctrl + a");
  handler.addHotKey("b","ctrl + b");
  handler.addHotKey("del","DELETE");
  //handler.addHotKey("esc","ESC");
}

void draw(){
  
}

void bindingPressed(keyAction a){
  println(a.name);
  if(a.name.equals("esc")){
    key = 0;
  }
}

void binding(keyAction a){
  switch(a.action){
    case KEY_PRESSED:
      println(a.name + " pressed");
      break;
    
    case KEY_RELEASED:
      println(a.name + " released");
      break;
    
    case KEY_TYPED:
      println(a.name + " typed");
      break;
  }
}