import java.lang.reflect.*;

final int KEY_PRESSED = 1;
final int KEY_RELEASED = 2;
final int KEY_TYPED = 3;

final String keyHandlerVersion = "";

public class keyHandler{
  PApplet parent;
  Method bindingPressed;
  Method bindingReleased;
  Method bindingTyped;
  Method binding;
  
  final String bP = "bindingPressed";
  final String bR = "bindingReleased";
  final String bT = "bindingTyped";
  final String b = "binding";
  
  ArrayList<keyBind> hotKeys;
  
  //boolean escDisabled = false;
  
  keyHandler(){}
  
  keyHandler(PApplet parent_){
    println("********************************\n" +
            " keyHandler Version Alpha 0.0.0 \n" + 
            "********************************");
    
    parent = parent_;
    parent.registerMethod("keyEvent", this);
    
    bindingPressed = createMethod(bP);
    bindingReleased = createMethod(bR);
    bindingTyped = createMethod(bT);
    binding = createMethod(b);
    
    hotKeys = new ArrayList<keyBind>(0);
  }
  
  Method createMethod(String n_){
    try{
      return parent.getClass().getMethod(n_, keyAction.class);
    }catch(Exception e){
      println("no" + n_ + "function");
      return null;
    }
  }
  
  public void keyEvent(KeyEvent event_){
    //called when key event occurs in parent, drawing allowed, unless noLoop() has been called
    int action = event_.getAction();//1 = press, 2 = release, 3 = type
    char key = event_.getKey();
    int keyCode = event_.getKeyCode();
    boolean ctrlDown = event_.isControlDown();
    boolean altDown = event_.isAltDown();
    boolean shiftDown = event_.isShiftDown();
    for(int i = 0; i < hotKeys.size(); i++){
      keyBind tmp = hotKeys.get(i);
      if(tmp.ctrl == ctrlDown && tmp.alt == altDown && tmp.shift == shiftDown){
        if(tmp.check(key, keyCode)){
          keyAction a = new keyAction(tmp.key, action);
          
          //let the user handle it
          if(binding != null){try{binding.invoke(parent, a);}catch(Exception e){}}
          
          switch(action){
            case KEY_PRESSED:
              //call keyPressed method
              if(bindingPressed != null){try{bindingPressed.invoke(parent, a);}catch(Exception e){}}
              break;
            
            case KEY_RELEASED:
              //call keyReleased method
              if(bindingReleased != null){try{bindingReleased.invoke(parent, a);}catch(Exception e){}}
              break;
            
            case KEY_TYPED:
              //call keyTyped method
              if(bindingTyped != null){try{bindingTyped.invoke(parent, a);}catch(Exception e){}}
              break;
          }
        }
      }
    }
  }
  
  void addHotKey(String name_, String keys_){
    //hotKeys.set(name_, keys_.toLowerCase());
    for(int i = 0; i < hotKeys.size(); i++){
      keyBind tmp = hotKeys.get(i);
      if(tmp.name.equals(name_)){
        tmp.create(name_, keys_);
        return;
      }
    }
    hotKeys.add(new keyBind().create(name_, keys_));
  }
  
  String getHotKey(){//return whatever is being pressed?
    return null;
  }
  
  //void disableESC(boolean v_){
  //  escDisabled = v_;
  //}
}

class keyAction{  
  String name = "";
  int action = 0;
  
  keyAction(String n_, int a_){
    name = n_;
    action = a_;
  }
}

class keyBind{
  String name = "";
  
  boolean ctrl = false;
  boolean alt = false;
  boolean shift = false;
  
  String keys = "";
  String key = "";
  
  keyBind(){}
  
  keyBind(String n_, boolean c_, boolean a_, boolean s_, String k_){
    name = n_;
    ctrl = c_;
    alt = a_;
    shift = s_;
    key = k_;
  }
  
  boolean check(char key_, int keyCode_){
    switch(key){
      case "delete":
        if(key_ == DELETE){return true;}
        break;
      
      case "backspace":
        if(key_ == BACKSPACE){return true;}
        break;
      
      case "tab":
        if(key_ == TAB){return true;}
        break;
      
      case "enter":
      case "return":
        if(key_ == ENTER || keyCode_ == RETURN){return true;}
        break;
      
      case "esc":
        if(key_ == ESC){return true;}
        break;
      
      case "up":
        if(key_ == UP){return true;}
        break;
      
      case "down":
        if(key_ == DOWN){return true;}
        break;
      
      case "left":
        if(key_ == LEFT){return true;}
        break;
      
      case "right":
        if(key_ == RIGHT){return true;}
        break;
    }
    return str(char(keyCode)).toLowerCase().equals(key);
  }
  
  String keys(){
    return keys;
  }
  
  keyBind create(String name_, String keys_){
    name = name_;
    keys = keys_;
    
    ctrl = false;
    alt = false;
    shift = false;
    
    String[] tmp = split(keys_, " ");
    for(int i = 0; i < tmp.length; i++){
      switch(tmp[i].toLowerCase()){
        case "ctrl":
          ctrl = true;
          break;
        
        case "alt":
          alt = true;
          break;
        
        case "shift":
          shift = true;
          break;
      }
    }
    
    key = tmp[tmp.length - 1].toLowerCase();
    
    return this;
  }
}