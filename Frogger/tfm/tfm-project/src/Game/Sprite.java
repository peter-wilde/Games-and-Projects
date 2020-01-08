package Game;

import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.*;
import java.util.*;
import java.math.*;
import java.awt.image.AffineTransformOp;
import java.awt.geom.AffineTransform;

public class Sprite {
	/** 
	 * The image for the sprite
	 * image holds the image file
	 * scale holds a settable scale to apply to the image
	 * scaledInt holds calculation of float to int that can be used with
	 * 	image.getScaledInstance(int, int, int)
	 */
	private Image image;
	//private Image scaledImage;
	private BufferedImage buffered;
	private double scale;
	private int scaledInt;
	
	double rotationRequired;
	double locationX;
	double locationY;
	AffineTransform tx;
	AffineTransformOp op;

	/**
	 * initialization
	 */
	public Sprite(Image image, double scale) {
		this.image = image;
		System.out.println(image.getWidth(null) +  " " + image.getHeight(null));
		this.scale = scale;
		scaledInt = (int) (35 * this.scale);
		this.image = this.image.getScaledInstance(scaledInt, scaledInt, 0);
		
		buffered = new BufferedImage(this.image.getWidth(null), this.image.getHeight(null), BufferedImage.TYPE_INT_ARGB);
		buffered.getGraphics().drawImage(this.image, 0, 0, null);
		buffered.getGraphics().dispose();
		
		locationX = buffered.getWidth(null) / 2;
		locationY = buffered.getHeight(null) / 2;
		rotationRequired = Math.toRadians(0);
		
	}
	
	/**
	 * Get  width of sprite
	 * @return width of sprite
	 */
	public int getWidth() {
		return image.getWidth(null);
	}

	/**
	 * Got height of  sprite
	 * @return height of sprite
	 */
	public int getHeight() {
		return image.getHeight(null);
	}
	
	/**
	 * Set scale of sprite
	 */
	
	public void setScale(double scale) {
		this.scale = scale;
		image = this.image.getScaledInstance(scaledInt, scaledInt, 0);
	}

	/**
	 * rotates image counterclockwise
	 */
	public void rotateLeft() {
		rotationRequired = Math.toRadians(270);
	}
	
	/**
	 * rotates image clockwise
	 */
	public void rotateRight() {
		rotationRequired = Math.toRadians(90);
	}
	
	public void rotateFull() {
		rotationRequired = Math.toRadians(180);
	}

	public void rotationRequired(int i) {
		// TODO Auto-generated method stub
		rotationRequired = Math.toRadians(i);
	}
	/**
	 * Draw the sprite onto board with x and y locations
	 * 
	 * @param g
	 * @param x
	 * @param y 
	 */
	public void draw(Graphics g,int x,int y) {
//		g.drawImage(image, x, y, null);
//		g.drawImage(buffered, x, y, null);
		tx = AffineTransform.getRotateInstance(rotationRequired, locationX, locationY);
		op = new AffineTransformOp(tx, AffineTransformOp.TYPE_BILINEAR);

		g.drawImage(op.filter(buffered, null), x, y, null);
		System.out.println("x: " + x + " y: " + y);
	}

}