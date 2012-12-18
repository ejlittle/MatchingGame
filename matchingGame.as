package
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class matchingGame extends MovieClip
	{
		//Game Constants
		private static const boardWidth: uint = 4;
		private static const boardHeight: uint = 4;
		private static const cardHorizontalSpacing: Number = 85;
		private static const cardVerticalSpacing: Number = 114;
		private static const boardOffsetX: Number = 70;
		private static const boardOffsetY: Number = 45;
		private static const pointsForMatch: int = 100;
		private static const pointsForMiss: int = -5;
		
		//Private Variables
		private var firstCard:Card;
		private var secondCard:Card;
		private var cardsLeft:uint;
		private var gameScoreField:TextField;
		private var gameScore:int;
		private var gameStartTime:uint;
		private var gameTime:uint;
		private var gameTimeField:TextField;
				
		public function matchingGame():void
		{
			gameScoreField = new TextField();
			addChild(gameScoreField);
			
			gameTimeField = new TextField;
			gameTimeField.y = 15;
			addChild(gameTimeField);
			
			gameStartTime = getTimer();
			gameTime = 0;
			
			gameScore = 0;
			showGameScore();
			
			addEventListener(Event.ENTER_FRAME,showTime);
			
			//make a list of card numbers
			var cardlist:Array = new Array();
			for(var i:uint = 0; i < boardWidth*boardHeight/2; i++)
			{
				cardlist.push(i);
				cardlist.push(i);
			}
			
			cardsLeft = 0;
			for(var x:uint = 0; x < boardWidth; x++)
			{
				for(var y:uint = 0; y < boardHeight; y++)
				{
					var c:Card = new Card();
					c.buttonMode = true;
					c.stop();
					c.x = x * cardHorizontalSpacing + boardOffsetX;
					c.y = y * cardVerticalSpacing + boardOffsetY;
					var r:uint = Math.floor(Math.random()*cardlist.length);
					c.cardface = cardlist[r];
					cardlist.splice(r,1);
					addChild(c);
					c.addEventListener(MouseEvent.CLICK,clickCard);
					cardsLeft++;
				}
			}			
		}
		
		public function clickCard(event:MouseEvent)
		{
			var cardFlipWhoosh:Whoosh = new Whoosh();
			var thisCard:Card = (event.currentTarget as Card);
			
			if(firstCard == null)
			{
				playSound(cardFlipWhoosh);
				firstCard = thisCard;
				firstCard.startFlip(thisCard.cardface+2);
			}
			else if(firstCard == thisCard)
			{
				playSound(cardFlipWhoosh);
				firstCard.startFlip(1);
				firstCard = null;
				
				if(secondCard != null)
				{
					secondCard.startFlip(1);
					secondCard = null;
					
					/* firstCard = thisCard;
					firstCard.gotoAndStop(thisCard.cardface+2);*/
				}
			}
			else if(secondCard == null)
			{
				playSound(cardFlipWhoosh);
				secondCard = thisCard;
				secondCard.startFlip(thisCard.cardface+2);
				
				if(firstCard.cardface == secondCard.cardface)
				{
					//remove match
					removeChild(firstCard);
					removeChild(secondCard);
					
					//reset selection
					firstCard = null;
					secondCard = null;
					
					//add points
					gameScore += pointsForMatch;
					showGameScore();
					
					//check for game over
					cardsLeft -=2;
					if(cardsLeft == 0)
					{
						MovieClip(root).gameScore = gameScore;
						MovieClip(root).gameTime = clockTime(gameTime);
						MovieClip(root).gotoAndStop("gameover");
					}
				}
				else
				{
					gameScore += pointsForMiss;
					showGameScore();
				}
			}
			else
			{
				playSound(cardFlipWhoosh);
				firstCard.startFlip(1);
				secondCard.startFlip(1);
				firstCard = null;
				secondCard = null;
				
				/*firstCard = thisCard;
				firstCard.gotoAndStop(thisCard.cardface+2);*/
			}
			
		}//end clickCard function
		
		public function showGameScore()
		{
			gameScoreField.text = "Score: "+String(gameScore);
		}
		
		public function showTime(event:Event)
		{
			gameTime = getTimer()-gameStartTime;
			gameTimeField.text = "Time: "+clockTime(gameTime);
		}
		
		public function clockTime(ms:int)
		{
			var seconds:int = Math.floor(ms/1000);
			var minutes:int = Math.floor(seconds/60);
			seconds -= minutes*60;
			
			var timeString:String = minutes+":"+String(seconds+100).substr(1,2);
			
			return timeString;
		}
		
		public function playSound(soundObject:Object)
		{
			var channel:SoundChannel = soundObject.play();
		}
	}//end MatchingGame
}//end Package