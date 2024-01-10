int Breite = 20;
int Hoehe = 16;

int[][] Feld = new int[Breite][Hoehe];
boolean Win;
int uebrigeMinen;
PImage Flagge;
float SpawnRate = 0.2;

// SPEICHER WERTE DER ZELLE, DURCH DIE VERLOREN WURDE UM SIE LILA ZU FAERBEN
int x, y;

void setup(){
  
   size(600,360);                           //-1KA Zelle                           
   textSize(16);                            //0 normales Feld   
   uebrigeMinen = 0;                        //1-8Minen aussenrum   
   x = -1;                                  //9  Mine
   y = -1;                                  //10 Flagge auf Mine
   Win = false;                             //11 Flagge nicht auf Mine

   // MINEN ZUFAELLIG GENERIEREN
    for (int i = 0; i < Breite; i++){
        for (int a = 0; a < Hoehe; a++){
          
            if (random(1) < SpawnRate){
     
            Feld[i][a] = 9;
            uebrigeMinen++;}
                
            else{
                Feld[i][a] = -1;}
                
      }}
      Flagge = loadImage("Flag2.png");
        }

void draw(){
  
    background(60);
    
    // VERBLEIBENDE MINEN DARSTELLEN
    fill(240,240,240);
    text("remaining mines: " + uebrigeMinen,417,26);
    
    // SPIELBRETT DARSTELLEN
    for (int i = 0; i < Breite; i++){
       for (int j = 0; j < Hoehe; j++){
          
            // WENN KEINE MINE, FARBE DARSTELLEN
            if (Feld[i][j] >= 0 && Feld[i][j] <= 8){
              
                // AUFGEDECKTE FELDER
                fill(190,190,190);
                rect(i*20,40+(j*20),20,20);
                
              // FARBEN
             if (Feld[i][j] == 0) {
             fill(250);
             } else if (Feld[i][j] == 1) {
             fill(0, 0, 190);} 
             else if (Feld[i][j] == 2) {
             fill(0, 190, 190);} 
             else if (Feld[i][j] == 3) {
             fill(190, 0, 0);} 
             else if (Feld[i][j] == 4) {
             fill(190, 0, 190);} 
             else if (Feld[i][j] == 5) {
             fill(190, 190, 0);} 
             else if (Feld[i][j] == 6) {
             fill(0, 190, 0);} 
             else if (Feld[i][j] == 7) {
             fill(150, 110, 90);} 
             else if (Feld[i][j] == 8) {
             fill(150);} 
             else {
             fill(120);}
                
                //NUR NUMMER, WEN FELD NICHT 0
                if (Feld[i][j] != 0)
                {
                    text(Feld[i][j],6+(i*20),55+(j*20));
                    
                    
                 // AUTOMSTIDCHE FELDER
                 if (countNearbyFlags(i,j) == Feld[i][j]){
                        openNearbySafeSpaces(i,j);}
                }
            }
            // FLAGGEN
            else if (Feld[i][j] == 10 || Feld[i][j] == 11){
              
                fill(190,0,0);
                imageMode(CENTER);
                image (Flagge,10+(i*20),50+(j*20));}
            // UNBERUERTE FELDER
            else{
                fill(60 ,50,40);
                rect(i*20,40+(j*20),20,20);}
        }
    }
    
    // WENN VERLOREN
    if (x != -1){
      
        //ALLE MINEN ZEIGEN
        for (int i = 0; i < Breite; i++){
            for (int j = 0; j < Hoehe; j++){
                if (Feld[i][j] == 9){
                  
                    fill(0,0,0);
                    ellipse(10+(i*20),50+(j*20),20,20);}
            }
        }
        
         //VERLIERERBILDSCHIRM
        fill(150,20,150);
        text("press      [TAB]      to restart",114,26);
        fill(240,0,0);
        text("LOOOSER!",460,200);}
    
    // GEWINNERBILDSCHIRM
    if (uebrigeMinen == 0)
    {
            fill(150,20,150);
              text("press      [TAB]      to restart",114,26);
            fill(24,140,0);
            text("WINNER!",460,200);
            Win = true;}
          }


void keyPressed(){
  
    // SPIEL NEUSTARTEN
    if (keyCode == TAB && (x != -1 || Win)){
      
        setup();}
    
   //ESCAPE ZUM VERLASSEN
  if (key == ESC){
    exit();}
}

void mousePressed(){
  
    // EINGABEN MAUS VERHINDERN
    if (x == -1 && !Win){
 
         if (mouseButton == LEFT){
            if (Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] == 9 || Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] == 10){
                gameLoss(floor(mouseX / 20),floor((mouseY-40) / 20)); }
           else{
                openSpace(floor(mouseX / 20),floor((mouseY-40) / 20));}
        }
       
            //MINE
            if (Feld[floor(mouseX/20)][floor((mouseY-40) / 20)] == 9){
              
                Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] = 10;
                uebrigeMinen--; }
                
            // KEINE MINE
            else if (Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] == -1){
              
             Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] = 11;
             uebrigeMinen--;}
                
            //RICHTIGE ZELLE WIEDER RUECKGAENGIG MACHEN
            else if (Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] == 10){
              
             Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] = 9;
             uebrigeMinen++;}
            
            // FALSCHE ZELLE WIEDER RUECKGAENGIG MACHEN
            else if (Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] == 11){
              
             Feld[floor(mouseX / 20)][floor((mouseY-40) / 20)] = -1;
             uebrigeMinen++;}
        }
    }
void openSpace(int x, int y)
{
    //MIENE GETROFFEN
    if (Feld[x][y] == 9)
    {
        gameLoss(x,y);
    }
    
  
    Feld[x][y] = countNearbyMines(x,y);
   
    if (countNearbyMines(x,y) == 0){
        // UMBGEBENE ZELLEN ZAEHLEN
        for (int i = 0; i < 3; i++){
            for (int j = 0; j < 3; j++){
                // UEBERPRUEFEN OB AUSSERHALB DES FELDES
                if ((x+i-1) < 0 || (y+j-1) < 0 || (x+i-1) >= 20 || (y+j-1) >= 16){
                    continue;}
               
                else if (Feld[x+i-1][y+j-1] == -1 && countNearbyMines(x+i-1,y+j-1) == 0){
                    Feld[x+i-1][y+j-1] = countNearbyMines(x+i-1,y+j-1);
                    openSpace(x+i-1,y+j-1);}
            
                else{
                    Feld[x+i-1][y+j-1] = countNearbyMines(x+i-1,y+j-1);}
            }}}}

// ZAHLEN ZU ZELLE
int countNearbyMines(int x, int y){
    int mineCount = 0;
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 3; j++){
            if ((x+i-1) < 0 || (y+j-1) < 0 || (x+i-1) >= 20 || (y+j-1) >= 16){
                continue;}
            else{
                if (Feld[x+i-1][y+j-1] == 9 || Feld[x+i-1][y+j-1] == 10){
                    mineCount++;}
            }}}
         return mineCount;}

//FLAGGEN ZAEHLEN
int countNearbyFlags(int x, int y){
    int flagCount = 0;
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 3; j++){
            if ((x+i-1) < 0 || (y+j-1) < 0 || (x+i-1) >= 20 || (y+j-1) >= 16){
                continue; }
            else{
                if (Feld[x+i-1][y+j-1] == 10 || Feld[x+i-1][y+j-1] == 11){
                    flagCount++;
                }}}}
      return flagCount;}


void openNearbySafeSpaces(int x, int y){
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 3; j++){
            if ((x+i-1) < 0 || (y+j-1) < 0 || (x+i-1) >= 20 || (y+j-1) >= 16){
                continue;}
            else{
                //AUTOMATISCH ERFOLGREICH
                if (Feld[x+i-1][y+j-1] == -1){
                    openSpace(x+i-1,y+j-1);}
                
                else if (Feld[x+i-1][y+j-1] == 9){
                    gameLoss(x+i-1,y+j-1);}
            }}}}

// ZELLE SPEICHERN
void gameLoss(int e, int r){
    x = e;
    y = r;}
