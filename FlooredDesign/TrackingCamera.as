﻿package  {
	
		
		var calibrateThresh : uint = 25;
		
		var A, B, C, D;
		
			// calc the transform matrix
			
			A = tightest_group(calibrate0s, calibrateThresh);
			B = tightest_group(calibrate1s, calibrateThresh);
			C = tightest_group(calibrate2s, calibrateThresh);
			D = tightest_group(calibrate3s, calibrateThresh);
			
			trace(A, B, C, D);
			
			var xs : Vector3D = new Vector3D(0, 1, 0, 1);
			var ys : Vector3D = new Vector3D(0, 0, 1, 1);
			var zs : Vector3D = new Vector3D(0, 0, 0, 0);
			var ws : Vector3D = new Vector3D(1, 1, 1, 1);
			
			var m : Matrix3D = new Matrix3D();
			
			// do the 'correction'
			var cameraBase : Point = new Point(camW / 2, camH);
			
			var correctionFactor : Number = 1e-20;
			
			var Az : Number = 0;
			var Bz : Number = 0;
			var Cz : Number = 0;
			var Dz : Number = 0;
			
			var furthestPoint : Point = A;
			
			if ( B.subtract(cameraBase).length > furthestPoint.subtract(cameraBase).length )
				furthestPoint = B;
			
			if ( C.subtract(cameraBase).length > furthestPoint.subtract(cameraBase).length )
				furthestPoint = C;
				
			if ( D.subtract(cameraBase).length > furthestPoint.subtract(cameraBase).length )
				furthestPoint = D;
			
			if (furthestPoint == A)
				Az = correctionFactor;
				
			if (furthestPoint == B)
				Bz = correctionFactor;
			
			if (furthestPoint == C)
				Cz = correctionFactor;
				
			if (furthestPoint == D)
				Dz = correctionFactor;
			
			// end 'correction'
			
			// slightly off so the det of the matrix can be non zero
			m.copyRowFrom(0, new Vector3D(A.x, A.y, Az, 1));
			m.copyRowFrom(1, new Vector3D(B.x, B.y, Bz, 1));
			m.copyRowFrom(2, new Vector3D(C.x, C.y, Cz, 1));
			m.copyRowFrom(3, new Vector3D(D.x, D.y, Dz, 1));
			
			var mi : Matrix3D = m.clone();
			trace( mi.invert() );
			
			var abcd : Vector3D = mi.transformVector(xs);
			var efgh : Vector3D = mi.transformVector(ys);
			var ijkl : Vector3D = mi.transformVector(zs);
			var mnop : Vector3D = mi.transformVector(ws);
			
			transformMatrix =  new Matrix3D();
			
			transformMatrix.copyRowFrom(0, abcd);
			transformMatrix.copyRowFrom(1, efgh);
			transformMatrix.copyRowFrom(2, ijkl);
			transformMatrix.copyRowFrom(3, mnop);
			
			footTracker = new FootTracker(cam, camW, camH);
			
		
		private function transformPoint(point:Point) : Point {
			
			if (transformMatrix == null)
				return new Point();
			
			var inPoint : Vector3D = new Vector3D(point.x, point.y, 0);
			
			var newPoint : Vector3D = transformMatrix.transformVector(inPoint);
			
			return new Point(newPoint.x, newPoint.y);
			
		}
		
		public function track() : Point {
			
			var originalPoint : Point = footTracker.track();
			
			if (originalPoint == null)
				return new Point();
			
			return transformPoint( originalPoint );
			
		}