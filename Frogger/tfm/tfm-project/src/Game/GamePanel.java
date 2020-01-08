package Game;

import java.awt.*;
import java.awt.List;
import java.io.*;
import java.util.*;
import javax.swing.*;
import java.awt.image.*;
import javax.imageio.*;
import java.awt.Image;
import java.text.*;
import java.awt.Font;
import java.awt.font.FontRenderContext;
import java.awt.font.TextLayout;


/**
 * The GamePanel draws the background and elements when repainted.
 * This class along with GameView implements the view part
 * of the MVC pattern.
 */
public class GamePanel extends JPanel {
	private GameModel model;
	private GameView view;
	private File file;
	private Frog frog;
	LinkedList<Lilypad> lilypads;
	LinkedList<Log> logs;
	private Graphics2D g2;
	
	
	/**
	 * Set up the instance variables and the focus.
	 * @param model the model of this Froggor game
	 * @param view the view of this Froggor game
	 */
	public GamePanel (GameModel model, GameView view, File file) {
		this.model = model;
		this.view = view;
		this.file = file;
		lilypads = new LinkedList<Lilypad>();
		logs = new LinkedList<Log>();
		// so this JPanel can listen to the keyboard
		this.setFocusable(true);
	}
	
	/**
	 * 
	 */
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
		// Should be safe cast all the time, Graphics2D is a
		// subclass of Graphics
		// Create a supplemental Graphics2D object, g2
		Graphics2D g2 = (Graphics2D) g;
		
		BufferedImage background = null;
		// testing
		 try {
			background = ImageIO.read(this.file);
		} catch (IOException e) {
			System.out.println("could not read background file");
		}
		/* try {
				background = ImageIO.read(this.file);
			} catch (IOException e) {
				System.out.println("could not read file");
			}
		 
		try {
			background = ImageIO.read(new File("src/Game/FroggorSpritesBackground.png"));
			System.out.println("Image read successfully");
		} catch (IOException e) {
			System.out.println("could not read file");
		}*/
		
		Image scaled = background.getScaledInstance(this.getWidth(), this.getHeight(), Image.SCALE_DEFAULT);
		g.drawImage(scaled, 0, 0, null);
		
		// This was to test for position of frog, un comment line below if you want
		//System.out.println( model.getX() + ", " + model.getY() );
		
		// This will show how many lives in the bottom right
		for(int l = model.getLives(); l > 0; l--){
			Image frogImage = null;
			try {
				frogImage = ImageIO.read(new File("src/Game/FroggorSprite2.png"));
			} catch (IOException e) {
				System.out.println(e);
			}
			g.drawImage(frogImage, (this.getWidth() - 10 - (39*l)) , this.getHeight() - 45, null);
		}
		
		String score = "Score: " + model.getScore();
		String lives = "Lives";
		//g.drawString(s, 10, 10);
		/*AttributedString attrString = new AttributedString(s);
		AttributedCharacterIterator sIter = attrString.getIterator();
		g.drawString(sIter, 20, 20);
		*/
		FontRenderContext frc = g2.getFontRenderContext();
		Font f = new Font("Showcard Gothic",Font.BOLD, 30);
		TextLayout scoreTL = new TextLayout(score, f, frc);
		TextLayout livesTL = new TextLayout(lives, f, frc);
		//Dimension theSize=getSize();
		g2.setColor(Color.white);
		scoreTL.draw(g2, 30, this.getHeight() - 20);
		livesTL.draw(g2, this.getWidth() - 235, this.getHeight() - 20);
		
		for(int x = lilypads.size(); x > 0; x--)
			lilypads.remove();
		for(int x = logs.size(); x > 0; x--)
			logs.remove();
		
		//Drawing to first row
		for (int x = 0; x < model.getRowSize(1); x++){
			lilypads.add(new Lilypad(model.getXPad(1,x), model.getYRow(0)));
		}
		for (Lilypad pad : lilypads)
            pad.drawLilypad(g);
		
		//Drawing to second row
		for (int x = 0; x < model.getRowSize(2); x++){
			lilypads.add(new Lilypad(model.getXPad(2, x), model.getYRow(1)));
		}
		for (Lilypad pad : lilypads)
            pad.drawLilypad(g);
		
		//Drawing to third row
		for (int x = 0; x < model.getRowSize(3); x++){
			lilypads.add(new Lilypad(model.getXPad(3, x), model.getYRow(2)));
		}
		for (Lilypad pad : lilypads)
            pad.drawLilypad(g);
		
		//Drawing to fourth row
		for (int x = 0; x < model.getRowSize(4); x++){
			lilypads.add(new Lilypad(model.getXPad(4, x), model.getYRow(3)));
		}
		for (Lilypad pad : lilypads)
            pad.drawLilypad(g);
		
		// Creating the frog
		frog = new Frog("src/Game/FroggorSprite1.png", model.getX() , model.getY());
		// Orienting the frog	
		if (model.facingLeft) {
			frog.sprite.rotationRequired(270);
		} else if (model.facingRight) {
			frog.sprite.rotationRequired(90);
		} else if (model.facingDown) {
			frog.sprite.rotationRequired(180);
		} else if (model.facingUp) {
			frog.sprite.rotationRequired(0);
		}				
		frog.draw(g);
		
		// DRAW VEHICLES AFTER FROG
	}
}
