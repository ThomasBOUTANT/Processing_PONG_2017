// Les parametres de la fenetre
int screenX = 800;
int screenY = 500;

int score_pong1;
int score_pong2;

PImage img;

int x, y;
int deplacementX, deplacementY;

int posX_pong1, posY_pong1;
int posX_pong2, posY_pong2;

int largeur_pong;
int hauteur_pong;

void setup()
{
   size(800, 500); //screenX et screenY
   background(0);
   
   score_pong1 = 0;
   score_pong2 = 0;
   
   // Hauteur et largeur des pong
   largeur_pong = 20;
   hauteur_pong = 80;
   
   // Position de la balle;
   x = (int) screenX/2;
   y = (int) screenY/2; 
   deplacementX = 6;
   deplacementY = -3; 
  
   // Position de depart de pong1
   posX_pong1 = 15;
   posY_pong1 = 10;
   
   // Position de depart de pong2
   posX_pong2 = screenX - posX_pong1 - largeur_pong;
   posY_pong2 = posY_pong1;
   
   img = loadImage("http://share.net-expression.com/53b71f3a9838a/1", "png");
   //thread("reload");
}


void draw() 
{
   nettoyer();
   bouger();
   rebondir();
   dessiner();
}


void nettoyer() 
{  
    background(0);
}

void dessiner() 
{
    smooth();
    
    // Ligne mediane
    stroke(255);
    line( (int) screenX/2, 0, (int) screenX/2, screenY);
    
    if (score_pong1 >= 2 || score_pong2 >= 2)
    {
        imageMode(CENTER);
        img.resize(screenX/3, screenY/2);
        image(img, screenX/2, screenY/2);
    }
    
          
    if (keyPressed == true) 
    {  
      if (key == 'Z')
      {
         fill(255); rect(50, 10, 5, 5);  
      }
      else
      {
        fill(0); rect(50, 10, 5, 5);  
      }
      if (keyCode == UP)
      {
         fill(255); rect(70, 10, 5, 5);  
      }
      else
      {
        fill(0); rect(50, 10, 5, 5);  
      }
      
      fill(255); rect(90, 10, 5, 5); 
      
       
    } else {
      fill(0); rect(50, 10, 5, 5);  
      fill(0); rect(70, 10, 5, 5);  
      fill(0); rect(90, 10, 5, 5);    
    }

    

    
    
    
    // But de pong1
    stroke(130);
    line( (int) screenX/5, (int) screenY/4 , (int) screenX/5, (int) 3*screenY/4);
    stroke(130);
    line( 0, (int) screenY/4 , (int) screenX/5, (int) screenY/4);
    stroke(130);
    line( 0, (int) 3*screenY/4 , (int) screenX/5, (int) 3*screenY/4);
    
    // But de pong2
    stroke(130);
    line( (int) 4*screenX/5, (int) screenY/4 , (int) 4*screenX/5, (int) 3*screenY/4);
    stroke(130);
    line( (int) 4*screenX/5, (int) screenY/4 , screenX, (int) screenY/4);
    stroke(130);
    line( (int) 4*screenX/5, (int) 3*screenY/4 , screenX, (int) 3*screenY/4);

    fill(255);
    rect(posX_pong1,posY_pong1,largeur_pong,hauteur_pong); //pong1
    fill(255);
    rect(posX_pong2,posY_pong2,largeur_pong,hauteur_pong); //pong2
    
    fill(255);
    ellipse(x,y,largeur_pong,largeur_pong);
    
}

void bouger() 
{
 x = x + deplacementX;
 y = y + deplacementY;
 
 //posY_pong1 = (mouseY);
 
 if (keyPressed == true) {
    if (keyCode == LEFT) {
      posY_pong2 -= 10;
    }
    else if(keyCode == RIGHT)
    {
      posY_pong2 += 10;
    }
    
    if (key == 'q') {
      posY_pong1 -= 10;
    }
    else if(key == 'd')
    {
      posY_pong1 += 10;
    }
 }
 
 if (posY_pong1 > screenY - hauteur_pong)
 {
   posY_pong1 = screenY - hauteur_pong;
 }
 if (posY_pong1 < 0)
 {
   posY_pong1 = 0;
 }
 if (posY_pong2 > screenY - hauteur_pong)
 {
   posY_pong2 = screenY - hauteur_pong;
 }
 if (posY_pong2 < 0)
 {
   posY_pong2 = 0;
 }
 
}

void rebondir()
{
  // si on est trop à droite et que le déplacement horizontal est positif
  if (x > screenX - largeur_pong && deplacementX > 0) 
  {
     deplacementX = -deplacementX; // inverser la valeur
     println("BUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUTTTTT PONG1 !!!!");
     score_pong1++;
     println(score_pong1 + " - " + score_pong2);
   }
   
   if (x < largeur_pong && deplacementX < 0) 
   {
     deplacementX = -deplacementX; // inverser la valeur
     //noLoop();
    // println("GAME OVER");   
     println("BUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUTTTTT PONG2 !!!!");
     score_pong2++;
     println(score_pong1 + " - " + score_pong2);
   }
   
   
   if (y < largeur_pong && deplacementY < 0) 
   {
     deplacementY = -deplacementY;
   }
   
   if (y > screenY - largeur_pong && deplacementY > 0) 
   {
     deplacementY = -deplacementY;
   }



   if (x<posX_pong1 + largeur_pong && y>posY_pong1 && y<posY_pong1+hauteur_pong)
   {
     deplacementX = -deplacementX; // inverser la valeur
   }
   if (x>posX_pong2 && y>posY_pong2 && y<posY_pong2+hauteur_pong)
   {
     deplacementX = -deplacementX; // inverser la valeur
   }  
}