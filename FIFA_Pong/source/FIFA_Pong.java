import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FIFA_Pong extends PApplet {

/*
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
*/

int score_pong1;
int score_pong2;

PImage logo1, logo2; // recupere les logos des 2 equipes

float x, y;
float speedX, speedY;

float posX_pong1, posY_pong1;
float posX_pong2, posY_pong2;

float[] posX_team1 = new float[11]; float[] posY_team1 = new float[11];
float[] posX_team2 = new float[11]; float[] posY_team2 = new float[11];

float l_pong; // largeur du pong
float h_pong; // hauteur du pong

float rBall; // rayon de la balle

float r_players; // rayon des joueurs

int playerID1, playerID2;
boolean player1HasChosen;

int ledPin1 = 10;
int ledPin2 = 11;
int  ctsPin1 = 2;
int ctsPin2 = 3;
//Arduino arduino;

// states
final int stateMenu = 0;
final int stateGame = 1;
final int stateStats = 2;
int state = 1;//stateMenu;
// font
PFont font;

String url = "http://api.football-data.org/v1/teams/";
JSONObject json1, json2, json3, json4;

int numTeam1 = 526;  
int numTeam2 = 543; 

String team1, team2;
JSONArray players1, players2;

// keyboard functions

public void keyPressed() {
  // keyboard. Also different depending on the state.
  switch (state) {
    case stateMenu: keyPressedForStateMenu(); break;
    case stateGame: keyPressedForStateGame(); break;
    case stateStats: keyPressedForStateStats(); break;
    default: println ("Unknown state (in keypressed) " + state + " ++++++"); exit(); break;
  } // switch
  //
}

public void keyPressedForStateMenu() {
  if(!player1HasChosen){
       switch(key) {
          case '1': playerID1 = 1; player1HasChosen = true; break;
          case '2': playerID1 = 2; player1HasChosen = true; break;
          case '3': playerID1 = 3; player1HasChosen = true; break;
          case '4': playerID1 = 4; player1HasChosen = true; break;
          case '5': playerID1 = 5; player1HasChosen = true; break;
          case '6': playerID1 = 6; player1HasChosen = true; break;
          case '7': playerID1 = 7; player1HasChosen = true; break;
          case '8': playerID1 = 8; player1HasChosen = true; break;
          case '9': playerID1 = 9; player1HasChosen = true; break;
          case 'A': case 'a': playerID1 = 10; player1HasChosen = true; break;
          case 'B': case 'b': playerID1 = 11; player1HasChosen = true; break;
          case 'x': case 'X': exit(); break;
          default: break;
        }
  }
  else{
     switch(key) {
          case '1': playerID2 = 1; state = stateGame; break;
          case '2': playerID2 = 2; state = stateGame; break;
          case '3': playerID2 = 3; state = stateGame; break;
          case '4': playerID2 = 4; state = stateGame; break;
          case '5': playerID2 = 5; state = stateGame; break;
          case '6': playerID2 = 6; state = stateGame; break;
          case '7': playerID2 = 7; state = stateGame; break;
          case '8': playerID2 = 8; state = stateGame; break;
          case '9': playerID2 = 9; state = stateGame; break;
          case 'A': case 'a': playerID2 = 10; state = stateGame; break;
          case 'B': case 'b': playerID2 = 11; state = stateGame; break;
          case 'x': case 'X': exit(); break;
          default: break;
      }
  }

}

public void keyPressedForStateGame() {
  switch(key) {
      case 'm': case 'M': state = stateMenu; player1HasChosen = false; break;
      default: break;
  }
}

public void keyPressedForStateStats() {
  switch(key) {
      case 'm': case 'M': state = stateMenu; break;
      default: break;
  }
} 


public void showMenu() {
  background(0);
  fill(255,255,255);
  textSize(32);
  text(" Choose your team ", width / 3, 100, 3);
  textSize(20);
  text(team1, width / 10,150);
  text(team2, 900,150);
  textSize(32);
  text(" Choose your player ", width / 3, 200, 3);
  textSize(20);
  // TEAM 1
  text("Player 1 :", width / 10,250);
  text("Player 2 :", width / 10,270);
  text("Player 3 :", width / 10,290);
  text("Player 4 :", width / 10,310);
  text("Player 5 :", width / 10,330);
  text("Player 6 :", width / 10,350);
  text("Player 7 :", width / 10,370);
  text("Player 8 :", width / 10,390);
  text("Player 9 :", width / 10,410);
  text("Player A :", width / 10,430);
  text("Player B :", width / 10,450);
  // TEAM 2
  text("Player 1 :", 7 * width / 10,250);
  text("Player 2 :", 7 * width / 10,270);
  text("Player 3 :", 7 * width / 10,290);
  text("Player 4 :", 7 * width / 10,310);
  text("Player 5 :", 7 * width / 10,330);
  text("Player 6 :", 7 * width / 10,350);
  text("Player 7 :", 7 * width / 10,370);
  text("Player 8 :", 7 * width / 10,390);
  text("Player 9 :", 7 * width / 10,410);
  text("Player A :", 7 * width / 10,430);
  text("Player B :", 7 * width / 10,450);
  

  for(int i=0;i<11;i++){
    text(players1.getJSONObject(i).getString("name"),width / 10 + 100,250+20*i);
  }
  for(int i=0;i<11;i++){
    text(players2.getJSONObject(i).getString("name"), 7 * width / 10 + 100,250+20*i);
  }
  
  text("Press x to quit ", 500, 650);
  
} 

public void handleStateStats() {
  background(0);
  fill(255,255,255);
  textSize(32);
  text(" See football statistics ", 150, 100, 3);
  textSize(14);
  text("..... some text ", 100, 200);
  //
} // func




public void setup()
{
    //width = 1200 et height = 700
   background(0);

  font = createFont("ARCARTER-78.vlw", 14);
  textFont(font);
   
   player1HasChosen = false;
   
   /*
   arduino = new Arduino(this, Arduino.list()[0], 57600);
   arduino.pinMode(ledPin1, Arduino.OUTPUT); 
   arduino.pinMode(ledPin2, Arduino.OUTPUT);
   arduino.pinMode(ctsPin1, Arduino.INPUT);
   arduino.pinMode(ctsPin2, Arduino.INPUT);
   */
   
   /*
   json1 = loadJSONObject(url + numTeam1 + "/players"); 
   json2 = loadJSONObject(url + numTeam2 + "/players"); 
   players1 = json1.getJSONArray("players"); players2 = json2.getJSONArray("players");
   
   json3 = loadJSONObject(url + numTeam1); team1 = json3.getString("name");
   json4 = loadJSONObject(url + numTeam2); team2 = json4.getString("name");
   */
   
   // Score des deux \u00e9quipes
   score_pong1 = 0;
   score_pong2 = 0;
   
   // Hauteur et largeur des pong
   l_pong = 20;
   h_pong = 80;
   
   // Rayons de la balle et des joueurs
   rBall = 5; //5
   r_players = 10; //20
   
   // Position et vitesse initiales de la balle
   initposition();
   initspeed();
     
   // Position de depart de pong1
   posX_pong1 = 15;
   posY_pong1 = (int) height/2;
   
   // Position de depart de pong2
   posX_pong2 = width - posX_pong1 - l_pong;
   posY_pong2 = posY_pong1;
   
   // Position des joueurs
   posX_team1[0] = 3*r_players; posY_team1[0] = height / 2;
   posX_team1[1] = width / 4; posY_team1[1] = height / 6;
   posX_team1[2] = width / 5; posY_team1[2] = 2 * height / 5;
   posX_team1[3] = width / 5; posY_team1[3] = 3 * height / 5;
   posX_team1[4] = width / 4; posY_team1[4] = 5 * height / 6;
   
   posX_team1[5] = 3 * width / 7; posY_team1[5] = height / 11;
   posX_team1[6] = width / 3; posY_team1[6] = height / 3;
   posX_team1[7] = width / 3; posY_team1[7] = 2 * height / 3;
   posX_team1[8] = 3 * width / 7; posY_team1[8] = 10 * height / 11;
   
   posX_team1[9] = 3 * width / 11; posY_team1[9] = height / 2;
   posX_team1[10] = 5 * width / 13; posY_team1[10] = height / 2;
  
   for (int i=0; i<11; i++)
   {
     posX_team2[i] = width - posX_team1[i];
     posY_team2[i] = posY_team1[i];
   }
  
   
   //load();
}

public void initspeed()
{
  speedX = 0;
  speedY = 0; 
}

public void initposition()
{
  // Position de la balle : au centre du terrain
   x = width/2; y = height/2;
}

public void initposition1()
{
  // Position de la balle : au centre du terrain de pong1
   x = 5 * width/11; y = height/2;
}

public void initposition2()
{
  // Position de la balle : au centre du terrain de pong2
   x = 6 * width / 11; y = height/2;
}


public void load()
{
  // Les images
  //img = loadImage("http://share.net-expression.com/53b71f3a9838a/1", "png");
  logo1 = loadImage("https://upload.wikimedia.org/wikipedia/en/thumb/1/11/FC_Girondins_de_Bordeaux_logo.svg/861px-FC_Girondins_de_Bordeaux_logo.svg.png", "png");
  logo2 = loadImage("https://upload.wikimedia.org/wikipedia/fr/c/ce/Fcna_logo_2008.png", "png");
   //thread("reload");

   //logo1 = loadImage(json3.getString("crestUrl"),"png");
   //logo2 = loadImage(json4.getString("crestUrl"), "png");
  
}




public void draw() 
{
   nettoyer();
   
    switch (state) {
  case stateMenu:
    showMenu();
    break;
  case stateGame:
       bouger();
       rebondir();
       dessiner();
    break;
     case stateStats:
    handleStateStats();
    break;
  default:
    println ("Unknown state (in draw) "
      + state
      + " ++++++++++++++++++++++");
    exit();
    break;
  }

}






public void nettoyer() 
{  
    background(0);
}








public void dessiner() 
{
    smooth();
    
    // Ligne mediane
    stroke(255); line( width/2, 0, width/2, height);
    
    //textSize(32);
    //text(players1.getJSONObject(playerID1-1).getString("name"), 300, 50);
    //text(players2.getJSONObject(playerID2-1).getString("name"), 700, 50);
    
    /*
    imageMode(CENTER);
    logo1.resize(width/10, height/10);
    logo2.resize(width/10, height/10);
    image(logo1, width/20, height/10);
    image(logo2, 19 * width/20, height/10);
    */
    
    // But de pong1
    stroke(130); line( width/11, height/4 , width/11, 3*height/4);
    stroke(130); line( 0, height/4 , width/11, height/4);
    stroke(130); line( 0, 3*height/4 , width/11, 3*height/4);
    
    // But de pong2
    stroke(130); line( 10*width/11, height/4 , 10*width/11, 3*height/4);
    stroke(130); line( 10*width/11, height/4 , width, height/4);
    stroke(130); line( 10*width/11, 3*height/4 , width, 3*height/4);

    score(); //affichage du score de chaque equipe
    
    for (int i=0; i<11; i++)
    {
      fill(0,0,255); ellipse(posX_team1[i],posY_team1[i],2*r_players,2*r_players); //affichage de l'equipe 1
      fill(255,255,0); ellipse(posX_team2[i],posY_team2[i],2*r_players,2*r_players); //affichage de l'equipe 2
    }
    
    
    fill(255); rect(posX_pong1,posY_pong1,l_pong,h_pong); //affichage de pong1
    fill(255); rect(posX_pong2,posY_pong2,l_pong,h_pong); //affichage de pong2
    
    fill(255); ellipse(x,y,2*rBall,2*rBall); //affichage de la balle    
    
    
}







public void bouger() 
{
  
   // Gestion de d\u00e9placements des pongs
   /*
   int ctsValue1 = arduino.digitalRead(ctsPin1);
   int ctsValue2 = arduino.digitalRead(ctsPin2);
   */
   
   //if (ctsValue1 == Arduino.HIGH){
   if (keyPressed == true && key == 'q') { posX_pong1 -= 5; }
   if (keyPressed == true && key == 'd') { posX_pong1 += 5; }
   if (keyPressed == true && key == 'z') { posY_pong1 -= 10; }
   if (keyPressed == true && key == 's') { posY_pong1 += 10; }
   //}
   //if (ctsValue2 == Arduino.HIGH){
   if (keyPressed == true && keyCode == LEFT) { posX_pong2 -= 5; }
   if (keyPressed == true && keyCode == RIGHT) { posX_pong2 += 5; }
   if (keyPressed == true && keyCode == UP) { posY_pong2 -= 10; }
   if (keyPressed == true && keyCode == DOWN) { posY_pong2 += 10; }
   //}
}









public void rebondir()
{
   // Gestion des collisions entre pong et les murs
   if (posY_pong1 > height - h_pong){ posY_pong1 = height - h_pong;}
   if (posY_pong1 < 0){posY_pong1 = 0;}
   if (posX_pong1 > width/2 - l_pong){posX_pong1 = width/2 - l_pong;}
   if (posX_pong1 < 0){posX_pong1 = 0;}
    
   if (posY_pong2 > height - h_pong){posY_pong2 = height - h_pong;}
   if (posY_pong2 < 0){posY_pong2 = 0;}
   if (posX_pong2 > width - l_pong){posX_pong2 = width - l_pong;}
   if (posX_pong2 < width/2){posX_pong2 = width/2;}
  
   
   // si on est trop \u00e0 droite et que le d\u00e9placement horizontal est positif
   if (x > width && speedX > 0) { 
       if ( height / 4 < y && y < 3 * height / 4)
       { 
             initposition2(); initspeed(); println("BUT PONG1 !"); score_pong1++; println(score_pong1 + " - " + score_pong2);
             //arduino.digitalWrite(ledPin2, 5);delay(1000);arduino.digitalWrite(ledPin2, 0);
       }
       else { 
             x = width - rBall; speedX = -abs(speedX);
             //arduino.digitalWrite(ledPin1, 0); 
       }
   }
   
   // si on est trop \u00e0 gauche : pong2 a marqu\u00e9
   if (x < 0 && speedX < 0) { 
       if ( height / 4 < y && y < 3 * height / 4)
       { 
             initposition1(); initspeed(); println("BUT PONG2 !"); score_pong2++; println(score_pong1 + " - " + score_pong2);
             //arduino.digitalWrite(ledPin1, 5);delay(1000);arduino.digitalWrite(ledPin1, 0);} //noLoop(); // println("GAME OVER"); 
       }
       else { 
             x = rBall; speedX = abs(speedX); 
             //arduino.digitalWrite(ledPin2, 0); 
       }
    }

   // collision de la balle avec le mur du haut
   if (y < l_pong && speedY < 0) { speedY = -speedY; }
   
   // collision de la balle avec le mur du bas
   if (y > height - l_pong && speedY > 0) { speedY = -speedY; }



   // collision de la balle avec pong1
   if (posX_pong1+l_pong-rBall<x        &&  x+speedX<=posX_pong1+l_pong  &&  posY_pong1<y                && y<posY_pong1+h_pong) { if ( posY_pong1 + (h_pong / 2) < y ) { speedY+=0.1f; } else { speedY-=0.1f; } x=posX_pong1+l_pong+rBall; speedX = abs(speedX); speedX++; }
   else if (posX_pong1-rBall<x+speedX   &&  x<=posX_pong1                &&  posY_pong1<y                && y<posY_pong1+h_pong) { x=posX_pong1-rBall;speedX = -1;}
   
   if (posX_pong1<x                     &&  x<posX_pong1+l_pong          &&  posY_pong1+h_pong-rBall<y   && y<=posY_pong1+h_pong) { y=posY_pong1+h_pong-rBall; speedY = 3;}
   else if (posX_pong1<x                &&  x<posX_pong1+l_pong          &&  posY_pong1-rBall<y+speedY   && y<=posY_pong1) { y=posY_pong1-rBall; speedY = -3; }
   
   // collision de la balle avec pong2
   if (posX_pong2+l_pong-rBall<x         &&  x+speedX<=posX_pong2+l_pong  &&  posY_pong2<y               && y<posY_pong2+h_pong) { x=posX_pong2+l_pong+rBall;speedX = 1; }
   else if (posX_pong2-rBall<x+speedX    &&  x<=posX_pong2                &&  posY_pong2<y               && y<posY_pong2+h_pong) { x=posX_pong2-rBall;speedX = -abs(speedX); speedX--; if ( posY_pong1 + (h_pong / 2) < y ) { speedY+=0.1f; } else { speedY-=0.1f; }}
   if (posX_pong2<x                      &&  x<posX_pong2+l_pong          &&  posY_pong2+h_pong-rBall<y  && y+speedY<=posY_pong2+h_pong) { y=posY_pong2+h_pong-rBall; speedY = 3; }
   else if (posX_pong2<x                 &&  x<posX_pong2+l_pong          &&  posY_pong2-rBall<y+speedY  && y<=posY_pong2) { y=posY_pong2-rBall; speedY = -3;}
   

   
   

   
   
   
   // collision de la balle avec les joueurs
   for (int i=0; i<11; i++)
   {
     if (  pow((x-posX_team1[i]),2) + pow((y-posY_team1[i]), 2) <= pow(rBall + r_players, 2)  ) 
     {
       float Xn = x-posX_team1[i];
       float Yn = y-posY_team1[i];
       float norm = sqrt(pow(Xn,2)+pow(Yn,2));
       Xn /= norm;
       Yn /= norm;
       float Xt = Yn;
       float Yt = - Xn;
       float prodVect = speedX*Xt + speedY*Yt;
       speedX = Xn + prodVect * Xt;
       speedY = Yn + prodVect * Yt;
     }
     
     
     if (  pow((x-posX_team2[i]),2) + pow((y-posY_team2[i]), 2) < pow(rBall + r_players, 2)  ) { 
       float Xn = x-posX_team2[i];
       float Yn = y-posY_team2[i];
       float norm = sqrt(pow(Xn,2)+pow(Yn,2));
       Xn /= norm;
       Yn /= norm;
       float Xt = Yn;
       float Yt = - Xn;
       float prodVect = speedX*Xt + speedY*Yt;
       speedX = Xn + prodVect * Xt;
       speedY = Yn + prodVect * Yt;
     }
   }
   
   x = x + speedX;
   y = y + speedY;
   
}





public void score()
{
  // Que faut-il afficher ? Definition d'un panneau 5x5
  int[] pannelScore1 = {25};
  int[] pannelScore2 = {25};
  
  // On regarde le score de pong1 et on active les bonnes cases du panneau
  switch (score_pong1)
  {
    case 0: int[] pScore1_0 = {0, 1, 2, 3, 4, 5, 9, 10, 14, 15, 19, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_0; break;
    case 1: int[] pScore1_1 = {3, 4, 7, 9, 11, 14, 19, 24}; pannelScore1 = pScore1_1; break;
    case 2: int[] pScore1_2 = {0, 1, 2, 3, 4, 9, 10, 11, 12, 13, 14, 15, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_2; break;
    case 3: int[] pScore1_3 = {0, 1, 2, 3, 4, 9, 12, 13, 14, 19, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_3; break;
    case 4: int[] pScore1_4 = {0, 4, 5, 9, 10, 11, 12, 13, 14, 19, 24}; pannelScore1 = pScore1_4; break;
    case 5: int[] pScore1_5 = {0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 19, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_5; break;
    case 6: int[] pScore1_6 = {0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15, 19, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_6; break;
    case 7: int[] pScore1_7 = {0, 1, 2, 3, 4, 9, 13, 18, 23}; pannelScore1 = pScore1_7; break;
    case 8: int[] pScore1_8 = {0, 1, 2, 3, 4, 5, 9, 11, 12, 13, 15, 19, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_8; break;
    case 9: int[] pScore1_9 = {0, 1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 19, 20, 21, 22, 23, 24}; pannelScore1 = pScore1_9; break;
    case 10: int[] pScore1_10 = {0, 2, 3, 4, 5, 7, 9, 10, 12, 14, 15, 17, 19, 20, 22, 23, 24}; pannelScore1 = pScore1_10; break;
  }

  // On regarde le score de pong2 et on active les bonnes cases du panneau
  switch (score_pong2)
  {
    case 0: int[] pScore2_0 = {0, 1, 2, 3, 4, 5, 9, 10, 14, 15, 19, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_0; break;
    case 1: int[] pScore2_1 = {3, 4, 7, 9, 11, 14, 19, 24}; pannelScore2 = pScore2_1; break;
    case 2: int[] pScore2_2 = {0, 1, 2, 3, 4, 9, 10, 11, 12, 13, 14, 15, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_2; break;
    case 3: int[] pScore2_3 = {0, 1, 2, 3, 4, 9, 12, 13, 14, 19, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_3; break;
    case 4: int[] pScore2_4 = {0, 4, 5, 9, 10, 11, 12, 13, 14, 19, 24}; pannelScore2 = pScore2_4; break;
    case 5: int[] pScore2_5 = {0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 19, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_5; break;
    case 6: int[] pScore2_6 = {0, 1, 2, 3, 4, 5, 10, 11, 12, 13, 14, 15, 19, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_6; break;
    case 7: int[] pScore2_7 = {0, 1, 2, 3, 4, 9, 13, 18, 23}; pannelScore2 = pScore2_7; break;
    case 8: int[] pScore2_8 = {0, 1, 2, 3, 4, 5, 9, 11, 12, 13, 15, 19, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_8; break;
    case 9: int[] pScore2_9 = {0, 1, 2, 3, 4, 5, 9, 10, 11, 12, 13, 14, 19, 20, 21, 22, 23, 24}; pannelScore2 = pScore2_9; break;
    case 10: int[] pScore2_10 = {0, 2, 3, 4, 5, 7, 9, 10, 12, 14, 15, 17, 19, 20, 22, 23, 24}; pannelScore2 = pScore2_10; break;
  }
  
  // Affichage des bonnes cases au bon endroit
  for (int i= 0; i<25; i++)
  {
    for (int j= 0; j<pannelScore1.length; j++) { if (pannelScore1[j] == i) {fill(0,0,255); rect(width/2 - l_pong - (20-(5* (i%5))) - 5, 10 + (5 * (i/5)), 5, 5);} }  
    for (int k= 0; k<pannelScore2.length; k++) { if (pannelScore2[k] == i) {fill(200); rect(width/2 + l_pong + (5* (i%5)), 10 + (5 * (i/5)), 5, 5); }  } 
  }
}
  public void settings() {  size(1200, 700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FIFA_Pong" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
