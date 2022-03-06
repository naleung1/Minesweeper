
import de.bezier.guido.*;
private final static int NUM_ROWS = 16;
private final static int NUM_COLS = 16;
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

private MSButton[][] buttons; //2d array of minesweeper buttons

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  for (int i = 0; i < 30; i++)
    setMines();
}

public void setMines()
{
  //your code
  int randomRow = (int)(Math.random()*NUM_ROWS);
  int randomCol = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[randomRow][randomCol])) {
    mines.add(buttons[randomRow][randomCol]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  for (int i = 0; i < mines.size (); i++) {
    if (mines.get(i).flagged == false)
      return false;
  }
  for (int r = 0; r < NUM_ROWS; r++)
    for (int c = 0; c < NUM_COLS; c++)
      if (!mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
        return false;
  return true;
}
public void displayLosingMessage()
{
  //your code here
  for (int i = 0; i < mines.size (); i++)
    mines.get(i).clicked = true;
  buttons[15][2].setLabel("u");
  buttons[15][3].setLabel("r");
  buttons[15][5].setLabel("t");
  buttons[15][6].setLabel("r");
  buttons[15][7].setLabel("a");
  buttons[15][8].setLabel("s");
  buttons[15][9].setLabel("h");
  buttons[15][12].setLabel("k");
  buttons[15][13].setLabel("i");
  buttons[15][14].setLabel("d");
}
public void displayWinningMessage()
{
  //your code here
  fill(255, 0, 0);
  buttons[15][3].setLabel("G");
  buttons[15][4].setLabel("G");
  buttons[15][5].setLabel("E");
  buttons[15][6].setLabel("Z");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r = row - 1; r <= row + 1; r++) {
    for (int c = col - 1; c <= col + 1; c++) {
      if (isValid(r, c) == true && mines.contains(buttons[r][c]) ) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (!mines.contains(buttons[myRow][myCol]) && countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
          if (isValid(r, c) == true && buttons[r][c].clicked == false ) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill(0, x/3+100, y/3 + 100);
    else 
      fill( 100 );

    rect(x, y, width, height);
    fill(255, 155, 50);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
