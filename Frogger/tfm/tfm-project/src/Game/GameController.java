package Game;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import Game.GameModel;
import Game.GameView;


public class GameController implements ActionListener, KeyListener {
	private GameModel model;
	private GameView view;
	
	
	public GameController(GameModel model, GameView view) {
		this.model = model;
		this.view = view;
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		model.moveLilypads();
		model.moveX();
		view.repaint();
		// TODO Auto-generated method stub
		
	}

	/**
	 * This function will handle all keyboard inputs
	 * @param e, an event of KeyEvent
	 */
	@Override
	public void keyPressed(KeyEvent e) {
		
		int keyCode = e.getKeyCode();
	    switch( keyCode ) { 
	        case KeyEvent.VK_UP:	        	
	        	model.moveUP();
	        	view.repaint();
	            break;
	        case KeyEvent.VK_DOWN:
	        	model.moveDOWN();
	        	view.repaint();
	            break;
	        case KeyEvent.VK_LEFT:
	        	model.moveLEFT();
	        	view.repaint();
	            break;
	        case KeyEvent.VK_RIGHT :
	        	model.moveRIGHT();
	        	view.repaint();
	            break;
	        case KeyEvent.VK_SPACE :
	        	System.out.println("Spacebar to grab fly!");
	        	//model.addBonus();
	        	break;
	     }
	}

	@Override
	public void keyReleased(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void keyTyped(KeyEvent e) {
		// TODO Auto-generated method stub
		
	}

}
