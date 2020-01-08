package Game;
import java.awt.event.*;


public class FroggorMouseController implements MouseListener, MouseMotionListener {
	private GameModel model;
	private GameView view;
	
	/**
	 * @param model the model of this Pong game
	 * @param view the view of this Pong game
	 */
	public FroggorMouseController(GameModel model, GameView view) {
		this.model = model;
		this.view = view;
	}
	
	/*
	 * MouseListener event handlers
	 */ 

	/**
	 * Go back to view for possible popup menu.
	 */
	public void mouseClicked(MouseEvent event) {
		view.checkForTriggerEvent(event);
	} // end method mouseClicked

	/**
	 * Go back to view for possible popup menu.
	 */
	public void mousePressed(MouseEvent event) {
		view.checkForTriggerEvent(event);
	} // end method mousePressed

	/**
	 * nothing to do for mouse release
	 */
	public void mouseReleased(MouseEvent event) {

	} // end method mouseReleased

	/**
	 * clear status bar
	 */
	public void mouseEntered(MouseEvent event) {
		
	} // end method mouseEntered

	/**
	 * notify user that mouse is outside the panel
	 */
	public void mouseExited(MouseEvent event) {
		
	} // end method mouseExited


	/*
	 *  MouseMotionListener event handlers
	 */

	/*
	 * position of mouse controls paddle
	 */
	public void mouseDragged(MouseEvent event) {
	
	} // end method mouseDragged

	/*
	 * position of mouse controls paddle
	 */
	public void mouseMoved(MouseEvent event) {
		
	} // end method mouseMoved
	
}

