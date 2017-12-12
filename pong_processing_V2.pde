int score_pong1;
int score_pong2;

PImage img;

int x, y;
int speedX, speedY;

int posX_pong1, posY_pong1;
int posX_pong2, posY_pong2;

int largeur_pong;
int hauteur_pong;

int rayonBalle;



void setup()
{
   size(800, 500); //width et height
   background(0);
   
   // Score des deux équipes
   score_pong1 = 0;
   score_pong2 = 0;
   
   // Hauteur et largeur des pong
   largeur_pong = 20;
   hauteur_pong = 80;
   
   rayonBalle = 5;
   
   // Position et vitesse initiales de la balle
   initposition();
   initspeed();
  
   // Position de depart de pong1
   posX_pong1 = 15;
   posY_pong1 = 10;
   
   // Position de depart de pong2
   posX_pong2 = width - posX_pong1 - largeur_pong;
   posY_pong2 = posY_pong1;
   
   //load();
}

void initspeed()
{
  speedX = 0;
  speedY = 0; 
}

void initposition()
{
  // Position de la balle : au centre du terrain
   x = (int) width/2;
   y = (int) height/2;
}

void initposition1()
{
  // Position de la balle : au centre du terrain de pong1
   x = (int) width/4;
   y = (int) height/2;
}

void initposition2()
{
  // Position de la balle : au centre du terrain de pong2
   x = (int) 3*width/4;
   y = (int) height/2;
}


void load()
{
  // Les images
  img = loadImage("http://share.net-expression.com/53b71f3a9838a/1", "png");
   //thread("reload");
   
   // Les sons
      
   // Les videos
   
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
    stroke(255); line( (int) width/2, 0, (int) width/2, height);
    
    /*if (score_pong1 >= 10 || score_pong2 >= 10)
    {
        imageMode(CENTER);
        img.resize(width/3, height/2);
        image(img, width/2, height/2);
    }*/
    
    // But de pong1
    stroke(130); line( (int) width/5, (int) height/4 , (int) width/5, (int) 3*height/4);
    stroke(130); line( 0, (int) height/4 , (int) width/5, (int) height/4);
    stroke(130); line( 0, (int) 3*height/4 , (int) width/5, (int) 3*height/4);
    
    // But de pong2
    stroke(130); line( (int) 4*width/5, (int) height/4 , (int) 4*width/5, (int) 3*height/4);
    stroke(130); line( (int) 4*width/5, (int) height/4 , width, (int) height/4);
    stroke(130); line( (int) 4*width/5, (int) 3*height/4 , width, (int) 3*height/4);

    score(); //affichage du score de chaque equipe

    fill(255); rect(posX_pong1,posY_pong1,largeur_pong,hauteur_pong); //affichage de pong1
    fill(255); rect(posX_pong2,posY_pong2,largeur_pong,hauteur_pong); //affichage de pong2
    
    fill(255); ellipse(x,y,2*rayonBalle,2*rayonBalle); //affichage de la balle    
}







void bouger() 
{
   x = x + speedX;
   y = y + speedY;
 
   // Gestion de déplacements des pongs
   if (keyPressed == true && key == 'q') { posX_pong1 -= 5; }
   if (keyPressed == true && key == 'd') { posX_pong1 += 5; }
   if (keyPressed == true && key == 'z') { posY_pong1 -= 10; }
   if (keyPressed == true && key == 's') { posY_pong1 += 10; }
  
   if (keyPressed == true && keyCode == LEFT) { posX_pong2 -= 5; }
   if (keyPressed == true && keyCode == RIGHT) { posX_pong2 += 5; }
   if (keyPressed == true && keyCode == UP) { posY_pong2 -= 10; }
   if (keyPressed == true && keyCode == DOWN) { posY_pong2 += 10; }
   
 
   // Gestion des collisions entre pong et les murs
   if (posY_pong1 > height - hauteur_pong){ posY_pong1 = height - hauteur_pong;}
   if (posY_pong1 < 0){posY_pong1 = 0;}
   if (posX_pong1 > width/2 - largeur_pong){posX_pong1 = (int) width/2 - largeur_pong;}
   if (posX_pong1 < 0){posX_pong1 = 0;}
    
   if (posY_pong2 > height - hauteur_pong){posY_pong2 = height - hauteur_pong;}
   if (posY_pong2 < 0){posY_pong2 = 0;}
   if (posX_pong2 > width - largeur_pong){posX_pong2 = width - largeur_pong;}
   if (posX_pong2 < width/2){posX_pong2 = (int) width/2;}
 
}









void rebondir()
{
  // si on est trop à droite et que le déplacement horizontal est positif
  if (x > width && speedX > 0) 
  {
     initposition2(); initspeed();
     println("BUT PONG1 !"); score_pong1++; println(score_pong1 + " - " + score_pong2);
   }
   
   // si on est trop à gauche : pong2 a marqué
   if (x < 0 && speedX < 0) 
   {
     initposition1(); initspeed();
     //noLoop(); // println("GAME OVER");   
     println("BUT PONG2 !"); score_pong2++; println(score_pong1 + " - " + score_pong2);
   }
   
   // collision de la balle avec le mur du haut
   if (y < largeur_pong && speedY < 0) { speedY = -speedY; }
   
   // collision de la balle avec le mur du bas
   if (y > height - largeur_pong && speedY > 0) { speedY = -speedY; }

   // collision de la balle avec pong1
   if (posX_pong1+largeur_pong-rayonBalle<x && x<=posX_pong1+largeur_pong  &&  posY_pong1<y                          && y<posY_pong1+hauteur_pong) { speedX = abs(speedX); speedX++;}
   if (posX_pong1-rayonBalle<x              && x<=posX_pong1               &&  posY_pong1<y                          && y<posY_pong1+hauteur_pong) { speedX = -1;}
   if (posX_pong1<x                         && x<posX_pong1+largeur_pong   &&  posY_pong1+hauteur_pong-rayonBalle<y  && y<=posY_pong1+hauteur_pong) { speedY = 3;}
   if (posX_pong1<x                         && x<posX_pong1+largeur_pong   &&  posY_pong1-rayonBalle<y               && y<=posY_pong1) { speedY = -3;}
 
   
   
   // collision de la balle avec pong2
   if (posX_pong2+largeur_pong-rayonBalle<x && x<=posX_pong2+largeur_pong  &&  posY_pong2<y                          && y<posY_pong2+hauteur_pong) { speedX = 1;}
   if (posX_pong2-rayonBalle<x              && x<=posX_pong2               &&  posY_pong2<y                          && y<posY_pong2+hauteur_pong) { speedX = -abs(speedX); speedX--;}
   if (posX_pong2<x                         && x<posX_pong2+largeur_pong   &&  posY_pong2+hauteur_pong-rayonBalle<y  && y<=posY_pong2+hauteur_pong) { speedY = 3;}
   if (posX_pong2<x                         && x<posX_pong2+largeur_pong   &&  posY_pong2-rayonBalle<y               && y<=posY_pong2) { speedY = -3;}
}




void score()
{
  // Que faut-il afficher ? Definition d'un panneau 5x5
  boolean[] pannelScore1 = new boolean[25];
  boolean[] pannelScore2 = new boolean[25];
  
  // Au depart, les cases du panneau doivent etre noires
  for (int i=0; i<25; i++)
  {
    pannelScore1[i] = false;
    pannelScore2[i] = false;
  }
  
  // On regarde le score de pong1 et on active les bonnes cases du panneau
  switch (score_pong1)
  {
    case 0:
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[5] = true;
      pannelScore1[9] = true;
      
      pannelScore1[10] = true;
      pannelScore1[14] = true;
      
      pannelScore1[15] = true;
      pannelScore1[19] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
      break;
    case 1:  
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[7] = true;
      pannelScore1[9] = true;
      
      pannelScore1[11] = true;
      pannelScore1[14] = true;
      
      pannelScore1[19] = true;
      
      pannelScore1[24] = true;
      break;
    case 2:  
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[9] = true;
      
      pannelScore1[10] = true;
      pannelScore1[11] = true;
      pannelScore1[12] = true;
      pannelScore1[13] = true;
      pannelScore1[14] = true;
      
      pannelScore1[15] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
      break;
    case 3:  
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[9] = true;
      
      pannelScore1[12] = true;
      pannelScore1[13] = true;
      pannelScore1[14] = true;
      
      pannelScore1[19] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
      break;
    case 4:  
	  pannelScore1[0] = true;
	  pannelScore1[4] = true;
	  
	  pannelScore1[5] = true;
	  pannelScore1[9] = true;
	  
	  pannelScore1[10] = true;
	  pannelScore1[11] = true;
	  pannelScore1[12] = true;
	  pannelScore1[13] = true;
	  pannelScore1[14] = true;
	  
	  pannelScore1[19] = true;
	  
	  pannelScore1[24] = true;
      break;
    case 5:  
	  pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[5] = true;
      
      pannelScore1[10] = true;
	  pannelScore1[11] = true;
	  pannelScore1[12] = true;
	  pannelScore1[13] = true;
      pannelScore1[14] = true;
      
      pannelScore1[19] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
    
      break;
    case 6:  
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[5] = true;
      
      pannelScore1[10] = true;
	  pannelScore1[11] = true;
	  pannelScore1[12] = true;
	  pannelScore1[13] = true;
      pannelScore1[14] = true;
      
      pannelScore1[15] = true;
	  pannelScore1[19] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
      break;
    case 7:  
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
	  
	  pannelScore1[9] = true;
	  
	  pannelScore1[13] = true;
	  
	  pannelScore1[18] = true;
	  
	  pannelScore1[23] = true;
	 
      break;
    case 8:  
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[5] = true;
	  pannelScore1[9] = true;
      
	  pannelScore1[11] = true;
	  pannelScore1[12] = true;
	  pannelScore1[13] = true;
      
      pannelScore1[15] = true;
	  pannelScore1[19] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
      break;
    case 9:  
      pannelScore1[0] = true;
      pannelScore1[1] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
      
      pannelScore1[5] = true;
	  pannelScore1[9] = true;
      
	  pannelScore1[10] = true;
	  pannelScore1[11] = true;
	  pannelScore1[12] = true;
	  pannelScore1[13] = true;
	  pannelScore1[14] = true;
      
	  pannelScore1[19] = true;
      
      pannelScore1[20] = true;
      pannelScore1[21] = true;
      pannelScore1[22] = true;
      pannelScore1[23] = true;
      pannelScore1[24] = true;
	  
      break;
    case 10:  
	
	  pannelScore1[0] = true;
      pannelScore1[2] = true;
      pannelScore1[3] = true;
      pannelScore1[4] = true;
	  
	  pannelScore1[5] = true;
      pannelScore1[7] = true;
      pannelScore1[9] = true;
	  
	  pannelScore1[10] = true;
      pannelScore1[12] = true;
      pannelScore1[14] = true;
	  
	  pannelScore1[15] = true;
      pannelScore1[17] = true;
      pannelScore1[19] = true;
	  
	  pannelScore1[20] = true;
      pannelScore1[22] = true;
	  pannelScore1[23] = true;
      pannelScore1[24] = true;
     
      break;

  }
  
    // On regarde le score de pong2 et on active les bonnes cases du panneau
  switch (score_pong2)
  {
    case 0:
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[5] = true;
      pannelScore2[9] = true;
      
      pannelScore2[10] = true;
      pannelScore2[14] = true;
      
      pannelScore2[15] = true;
      pannelScore2[19] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
      break;
    case 1:  
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[7] = true;
      pannelScore2[9] = true;
      
      pannelScore2[11] = true;
      pannelScore2[14] = true;
      
      pannelScore2[19] = true;
      
      pannelScore2[24] = true;
      break;
    case 2:  
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[9] = true;
      
      pannelScore2[10] = true;
      pannelScore2[11] = true;
      pannelScore2[12] = true;
      pannelScore2[13] = true;
      pannelScore2[14] = true;
      
      pannelScore2[15] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
      break;
    case 3:  
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[9] = true;
      
      pannelScore2[12] = true;
      pannelScore2[13] = true;
      pannelScore2[14] = true;
      
      pannelScore2[19] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
      break;
    case 4:  
	  pannelScore2[0] = true;
	  pannelScore2[4] = true;
	  
	  pannelScore2[5] = true;
	  pannelScore2[9] = true;
	  
	  pannelScore2[10] = true;
	  pannelScore2[11] = true;
	  pannelScore2[12] = true;
	  pannelScore2[13] = true;
	  pannelScore2[14] = true;
	  
	  pannelScore2[19] = true;
	  
	  pannelScore2[24] = true;
      break;
    case 5:  
	  pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[5] = true;
      
      pannelScore2[10] = true;
	  pannelScore2[11] = true;
	  pannelScore2[12] = true;
	  pannelScore2[13] = true;
      pannelScore2[14] = true;
      
      pannelScore2[19] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
    
      break;
    case 6:  
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[5] = true;
     
      pannelScore2[10] = true;
	  pannelScore2[11] = true;
	  pannelScore2[12] = true;
	  pannelScore2[13] = true;
      pannelScore2[14] = true;
      
      pannelScore2[15] = true;
	  pannelScore2[19] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
      break;
    case 7:  
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
	  
	  pannelScore2[9] = true;
	  
	  pannelScore2[13] = true;
	  
	  pannelScore2[18] = true;
	  
	  pannelScore2[23] = true;
	 
      break;
    case 8:  
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[5] = true;
	  pannelScore2[9] = true;
      
	  pannelScore2[11] = true;
	  pannelScore2[12] = true;
	  pannelScore2[13] = true;
      
      pannelScore2[15] = true;
	  pannelScore2[19] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
      break;
    case 9:  
      pannelScore2[0] = true;
      pannelScore2[1] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
      
      pannelScore2[5] = true;
	  pannelScore2[9] = true;
      
	  pannelScore2[10] = true;
	  pannelScore2[11] = true;
	  pannelScore2[12] = true;
	  pannelScore2[13] = true;
	  pannelScore2[14] = true;
      
	  pannelScore2[19] = true;
      
      pannelScore2[20] = true;
      pannelScore2[21] = true;
      pannelScore2[22] = true;
      pannelScore2[23] = true;
      pannelScore2[24] = true;
	  
      break;
    case 10:  
	
	  pannelScore2[0] = true;
      pannelScore2[2] = true;
      pannelScore2[3] = true;
      pannelScore2[4] = true;
	  
	  pannelScore2[5] = true;
      pannelScore2[7] = true;
      pannelScore2[9] = true;
	  
	  pannelScore2[10] = true;
      pannelScore2[12] = true;
      pannelScore2[14] = true;
	  
	  pannelScore2[15] = true;
      pannelScore2[17] = true;
      pannelScore2[19] = true;
	  
	  pannelScore2[20] = true;
      pannelScore2[22] = true;
	  pannelScore2[23] = true;
      pannelScore2[24] = true;
     
      break;
  }
  
  // Affichage des bonnes cases au bon endroit
  for (int i= 0; i<25; i++)
  {
     if (pannelScore1[i]) {fill(200); rect((int) width/2 - largeur_pong - (20-(5* (i%5))) - 5, 10 + (5 * ((int)i/5)), 5, 5);}
     if (pannelScore2[i]) {fill(200); rect((int) width/2 + largeur_pong + (5* (i%5)), 10 + (5 * ((int)i/5)), 5, 5); }
  } 
}