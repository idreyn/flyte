﻿package org.flyte.collision{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.coreyoneil.collision.*
	/**
	 * 
	 * This class allows for pixel-perfect bitmap-based hit testing by creating
	 * bitmap representations of two DisplayObjects and looking at the area of their collision.
	 * NOTE:
	 * This class was 'borrowed' from the tink.ws.display.HitTest class from Tink.
	 * @see http://www.tink.ws/blog/files/as3/ComplexHitTestObject/srcview/index.html
	 * @author Ian Reynolds, Tink
	 */
	public class Collision {
		
		/**
		 * Used to determine whether two DisplayObject are touching. For less accurate collisions
		 * based on the DisplayObjects' bounding boxes, use the DisplayObject.hitTestObject method.
		 * @param target1 One of the DisplayObjects to test.
		 * @param target2 The other DisplayObject to test.
		 * @param accuracy The accuracy of the test (do not touch!)
		 * @return A boolean value of whether the two DisplayObjects touch.
		 * 
		 */
		public static function hitTestShape( target1:DisplayObject, target2:DisplayObject,  accuracy:Number = 1 ):Boolean {
			if(!target1.visible || !target2.visible) return false;
			return complexIntersectionRectangle(target1,target2,accuracy).width != 0;
		}
		
		public static function getAngle(a:DisplayObject,b:DisplayObject):*
		{
			var _c:CollisionList=new CollisionList(a)
			_c.addItem(b)
			_c.returnAngle=true
			_c.returnAngleType="deg"
			_c.checkCollisions();
			return _c.checkCollisions()[0].angle
		}
		
		public static function hitTestShape2(a:DisplayObject,b:DisplayObject):Boolean
		{
			var _c:CollisionList=new CollisionList(a)
			_c.addItem(b)
			var arr:Array=_c.checkCollisions()
			return arr.length > 0
		}
		public static function intersectionRectangle( target1:DisplayObject, target2:DisplayObject ):Rectangle {
			// If either of the items don't have a reference to stage, then they are not in a display list
			// or if a simple hitTestObject is false, they cannot be intersecting.
			if ( !target1.root || !target2.root || !target1.hitTestObject( target2 ) ) {
				return new Rectangle  ;
			}

			// Get the bounds of each DisplayObject.
			var bounds1:Rectangle = target1.getBounds( target1.root );
			var bounds2:Rectangle = target2.getBounds( target2.root );

			// Determine test area boundaries.
			var intersection:Rectangle = new Rectangle();
			intersection.x         = Math.max( bounds1.x, bounds2.x );
			intersection.y        = Math.max( bounds1.y, bounds2.y );
			intersection.width     = Math.min( ( bounds1.x + bounds1.width ) - intersection.x, ( bounds2.x + bounds2.width ) - intersection.x );
			intersection.height = Math.min( ( bounds1.y + bounds1.height ) - intersection.y, ( bounds2.y + bounds2.height ) - intersection.y );

			return intersection;
		}
		public static function complexIntersectionRectangle( target1:DisplayObject, target2:DisplayObject, accuracy:Number = 1 ):Rectangle {
			if ( accuracy <= 0 ) {
				throw new Error("ArgumentError: Error #5001: Invalid value for accuracy",5001);
			}

			// If a simple hitTestObject is false, they cannot be intersecting.
			if ( !target1.hitTestObject( target2 ) ) {
				return new Rectangle  ;
			}

			var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
			// If their boundaries are no interesecting, they cannot be intersecting.
			if ( hitRectangle.width * accuracy < 1 || hitRectangle.height * accuracy < 1 ) {
				return new Rectangle  ;
			}

			var bitmapData:BitmapData = new BitmapData( hitRectangle.width * accuracy, hitRectangle.height * accuracy, false, 0x000000 );

			// Draw the first target.
			bitmapData.draw( target1, Collision.getDrawMatrix( target1, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
			// Overlay the second target.
			bitmapData.draw( target2, Collision.getDrawMatrix( target2, hitRectangle, accuracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );

			// Find the intersection.
			var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );

			bitmapData.dispose();

			// Alter width and positions to compensate for accuracy
			if ( accuracy != 1 ) {
				intersection.x /= accuracy;
				intersection.y /= accuracy;
				intersection.width /= accuracy;
				intersection.height /= accuracy;
			}
			intersection.x += hitRectangle.x;
			intersection.y += hitRectangle.y;

			return intersection;
		}
		protected static function getDrawMatrix( target:DisplayObject, hitRectangle:Rectangle, accuracy:Number ):Matrix {
			var localToGlobal:Point;

			var matrix:Matrix;

			var rootConcatenatedMatrix:Matrix = target.root.transform.concatenatedMatrix;

			localToGlobal = target.localToGlobal( new Point( ) );
			matrix = target.transform.concatenatedMatrix;
			matrix.tx = localToGlobal.x - hitRectangle.x;
			matrix.ty = localToGlobal.y - hitRectangle.y;

			matrix.a = matrix.a / rootConcatenatedMatrix.a;
			matrix.d = matrix.d / rootConcatenatedMatrix.d;
			if ( accuracy != 1 ) {
				matrix.scale( accuracy, accuracy );
			}

			return matrix;
		}

	}

}