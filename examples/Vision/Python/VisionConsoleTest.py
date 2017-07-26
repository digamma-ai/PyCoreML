import objc
import Foundation
import Cocoa
import Vision
import VisionUtils


NSBitmapImageFileTypeJPEG = 3

def drawContour(region, box):
	count = region.pointCount()
	path = Cocoa.NSBezierPath.alloc().init()
	for i in range(0,count):
		pt = region.vut_pointAtIndex_(i)
		pt.x = box.origin.x + pt.x * box.size.width
		pt.y = box.origin.y + pt.y * box.size.height

		if i == 0:
			path.moveToPoint_(pt)
		else:
			path.lineToPoint_(pt)

		Cocoa.NSColor.greenColor().set()
		path.stroke()

def drawResults(srcImageURL, dstImageURL, results):
	image  = Cocoa.NSImage.alloc().initWithContentsOfURL_(srcImageURL)

	image.lockFocus()

	imageSize = image.size()

	for result in results:
		boundingBox = Vision.VNImageRectForNormalizedRect(result.boundingBox(), imageSize.width, imageSize.height)
		Cocoa.NSColor.redColor().set()
		Cocoa.NSBezierPath.strokeRect_(boundingBox)

		landmarks = result.landmarks()

		if landmarks.faceContour() != None:
			drawContour(landmarks.faceContour(), boundingBox)

		if landmarks.nose() != None:
			drawContour(landmarks.nose(), boundingBox)

		if landmarks.leftEye() != None:
			drawContour(landmarks.leftEye(), boundingBox)

		if landmarks.rightEye() != None:
			drawContour(landmarks.rightEye(), boundingBox)

		if landmarks.outerLips() != None:
			drawContour(landmarks.outerLips(), boundingBox)

	image.unlockFocus()

	imageRef, rect = image.CGImageForProposedRect_context_hints_(None, None, None)
	bitmap = Cocoa.NSBitmapImageRep.alloc().initWithCGImage_(imageRef)
	data = bitmap.representationUsingType_properties_(NSBitmapImageFileTypeJPEG, dict([(Cocoa.NSImageCompressionFactor, 1.0)]))
	res, error = data.writeToFile_options_error_(dstImageURL.path(), 0, None)
	if not res:
		print("ERROR: {0}".format(error))

def detectFaces(srcImageURL, dstImageURL):
	handler = Vision.VNImageRequestHandler.alloc().initWithURL_options_(srcImageURL, dict())
	faceLandmarksRequest = Vision.VNDetectFaceLandmarksRequest.alloc().init()

	res = handler.performRequests_error_([faceLandmarksRequest], None)
	if res :
		results = faceLandmarksRequest.results()
		i = 0
		for result in results:
			print("face: {0}".format(i))
			boundingBox = result.boundingBox()
			print("boundingBox: {0}".format(boundingBox))
			print("landmarks: {0}".format(result.landmarks()))

			i = i + 1

		drawResults(srcImageURL, dstImageURL, results)


def main():
	srcImageURL = Foundation.NSURL.fileURLWithPath_("test.jpg")
	dstImageURL = Foundation.NSURL.fileURLWithPath_("test_out.jpg")

	detectFaces(srcImageURL, dstImageURL)

if __name__ == "__main__":
	main()
