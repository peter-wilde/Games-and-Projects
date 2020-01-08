package Game;

import java.awt.Graphics;
/*import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
*/
public class Frog {

	private double x;
	private double y;
	//private double width;
	//private double heigth;
	protected Sprite sprite;

	/**
	 * Construct a Sprite 
	 * 
	 * @param name 
 	 * @param x 
	 * @param y 
	 */

	public Frog(String name, int x, int y) {
		this.sprite = SpriteList.get().getSprite(name);
		this.x = x;
		this.y = y;
	}


/**
 * draws the sprite
 * @param g
 */
	public void draw(Graphics g) {
		sprite.draw(g,(int) x,(int) y);
	}
	

	/**
	 * Get the x location of this entity
	 * 
	 * @return The x location of this entity
	 */
	public int getX() {
		return (int) x;
	}

	/**
	 * Get the y location of this entity
	 * 
	 * @return The y location of this entity
	 */
	public int getY() {
		return (int) y;
	}

}


/*package Game;

import java.awt.*;
import java.io.*;
import javax.swing.*;
import java.awt.image.*;
import javax.imageio.*;


public class Frog extends Characters{
	/**
	 * Creates the froggor sprite for player
	 * @param gameView 
	 * @param model 
	 *  
	 * @param spriteInit The game in which the ship is being created
	 * @param ref The reference to the sprite to show for the ship
	 * @param x The initial x location of the player's ship
	 * @param y The initial y location of the player's ship
	 *
	public Frog( String name, int x, int y) {
		super(name, x, y);
	}
}*/