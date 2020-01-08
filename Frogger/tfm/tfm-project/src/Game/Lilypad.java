package Game;
import java.awt.*;
import java.io.*;
import java.awt.image.*;
import javax.imageio.*;

public class Lilypad {
	
	private int x;
	private int y;
	private final int LILYSCALE = 50;
	private BufferedImage image;
	private Image scaledImage;

	public Lilypad(int x, int y) {
		try {
			this.image = ImageIO.read(new File("src/Game/lilypad2.png"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.x = x;
		this.y = y;
	}
	
	public void drawLilypad(Graphics g){
		scaledImage = this.image.getScaledInstance(LILYSCALE, LILYSCALE, 0);
		g.drawImage(scaledImage, x, y, null);
	}
}