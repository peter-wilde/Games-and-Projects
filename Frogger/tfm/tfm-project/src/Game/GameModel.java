package Game;

public class GameModel {

	
	
	private int[][] xPad =	{{0, 50, 100, 175, 225, 300, 500, 550, 600, 675},
							{50, 100, 700, 450, 600, 210, 270},
							{50, 100, 700, 450, 600, 210, 270},
							{50, 100, 700, 450, 600, 210, 270}};
	private int[] yRow = {100, 164, 228, 292};
	private int x, y, progress, yTrack, jumpsize, movespeed, frogMS, xBackground, lives, score, rowIndex;
	protected boolean facingLeft, facingRight, facingUp, facingDown;
	private  boolean pause, onPlatform;

	public GameModel(){
		x = 440;
		y = 676;
		xBackground= 982;
		score = progress = yTrack = 0;
		jumpsize = 32;
		lives = 3;
		movespeed = 3;
		facingUp = true;
		pause = false;
		onPlatform = false;
		rowIndex = 0;
		frogMS = 3;
	}

	/**
	 * This function will move the frog up and keep track of forward progress
	 */
	public void moveUP() {
		//flags will keep track of the direction frog is facing and update
		if (!facingUp) { 
			facingUp = true;
			facingDown = false;
			facingLeft = false;
			facingRight = false;
		}
		// This will increment progress as player goes further up
		if(progress <= yTrack){
			progress++;
			changeScore(1);
		}
		// This will cap yTrack based upon our array to prevent a HUGE bonus
		if(y > 40)
			yTrack++;
		//actual movement of frog. jumpsize depends on y value
		if (y <= 40 + jumpsize)
			y = 40;
		else if (y <= 292 )
			y -= jumpsize * 2;
		else y -= jumpsize;
		platformCheck();
	}
	/**
	 * This function will move the frog down
	 */
	public void moveDOWN() {		
		//flags will keep track of the direction frog is facing and update
		if (!facingDown) { 
			facingDown = true;
			facingUp = false;
			facingLeft = false;
			facingRight = false;
		}
		// This will prevent yTrack from becoming a HUGE negative number
		if(yTrack > 0)
			yTrack--;
		if (y >= (680  - jumpsize))
			y =  680;
		else if (y <= 292)
			y += jumpsize * 2;
		else y += jumpsize;
		platformCheck();
	}
	/**
	 * This function will move the frog to the left
	 */
	public void moveLEFT() {
		//flags will keep track of the direction frog is facing and update
		if (!facingLeft) { 
			facingLeft = true;
			facingUp = false;
			facingDown = false;
			facingRight = false;
		}		
		if (x < jumpsize)
			x = 0;
		else  x -= jumpsize;
		platformCheck();
	}
	/**
	 * This function will move the frog to the right
	 */
	public void moveRIGHT() {
		//flags will keep track of the direction frog is facing and update
		if (!facingRight) {
			facingRight = true;
			facingUp = false;
			facingDown = false;
			facingLeft = false;	
		}				
		if ((x > xBackground - 82 - jumpsize))
			x = xBackground - 82;
		else x += jumpsize;
		platformCheck();
	}
	
	/**
	 * These next 4 functions will return x and y values and are for moving the frog
	 * @return
	 */
	
	public int getX(){		
		return x;
	}
	
	public int getY(){		
		return y;
	}
	public void moveX(){
		if(onPlatform){
			x += frogMS;
		}
				
	}
	public void setRowIndex(){
		if (y == 292){
			rowIndex = 3;
			frogMS = movespeed;
		}
		if (y == 228){
			rowIndex = 2;
			frogMS = movespeed * -1;
		}
		if (y == 164){
			rowIndex = 1;
			frogMS = movespeed;
		}
		if (y == 100){
			rowIndex = 0;
			frogMS = movespeed * -1;
		}
	}
	//called after a jump
	public void platformCheck(){
		onPlatform = false;
		setRowIndex();
		if (y <= 292)
			for (int index = 0; index < xPad[rowIndex].length; index++){
				//checks if the frog is near the index of a lilypad, 15 is just random for testing
				if (x <= xPad[rowIndex][index] + 45 && x >=xPad[rowIndex][index] - 15){
					onPlatform = true;
				}
			}
	}
	
	/**
	 * These methods are for moving lilypads
	 */
	
	public void moveLilypads(){
		for (int row = 0; row < xPad.length; row++){
			movespeed = movespeed * -1;
			for (int z = 0; z < xPad[row].length; z++){
				xPad[row][z] += movespeed;
				if (xPad[row][z] > 1000){
					xPad[row][z] = -50;
				}
				if (xPad[row][z] < -50){
					xPad[row][z] = 1000;
				}
			}
		}
	}
	//get x position for the lilypad inside of the 2-d array
	public int getXPad(int row, int index){
		switch (row) {
			case 1: row = 1;
					return xPad[row-1][index];
			case 2: row = 2;
					return xPad[row-1][index];
			case 3: row = 3;
					return xPad[row-1][index];
			case 4: row = 4;
					return xPad[row-1][index];
		}
		return 0;
	}
	//gets the amount of lilypads in the row of the 2-d array
	public int getRowSize(int row){
		switch (row) {
		case 1: row = 1;
				return xPad[row-1].length;
		case 2: row = 2;
				return xPad[row-1].length;
		case 3: row = 3;
				return xPad[row-1].length;
		case 4: row = 4;
				return xPad[row-1].length;
		}
		return 0;
	}
	
	//returns the y value for the row
	public int getYRow(int index){
		return yRow[index];
	}
	
	/**
	 * Lives and score
	 */
	public int getLives(){
		return lives;
	}
	
	public int getScore(){
		return score;
	}
	
	public int getProgress(){
		return progress;
	}
	
	public void liveChange(int i){
		if(i == 1)
			lives++;
		else if(i == -1)
			lives--;
	}
	
	public void changeScore(int c){
		score += c;
	}
	
	public void addBonus(){
		changeScore(5);
	}

	public boolean getPause() {
		return pause;
	}

	public void setPause(boolean pause) {
		this.pause = pause;
	}

}
