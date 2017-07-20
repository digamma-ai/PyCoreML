import objc
import Foundation
import CoreML

MLFeatureProvider = objc.protocolNamed('MLFeatureProvider')

class MarsHabitatPricerInput(Foundation.NSObject):
	__pyobjc_protocols__ = [MLFeatureProvider]

	def initWithSolarPanels_greenhouses_size_(self, solarPanels, greenhouses, size):
		self = objc.super(MarsHabitatPricerInput, self).init()
		if self is None: return None

		self.solarPanels = solarPanels
		self.greenhouses = greenhouses
		self.size = size

		return self

	def featureNames(self):
		names = Foundation.NSSet.setWithArray_(["solarPanels", "greenhouses", "size"])
		return names

	def featureValueForName_(self, featureName):

		if featureName == "solarPanels":
			return CoreML.MLFeatureValue.featureValueWithDouble_(self.solarPanels)
		elif featureName == "greenhouses":
			return CoreML.MLFeatureValue.featureValueWithDouble_(self.greenhouses)
		elif featureName == "size":
			return CoreML.MLFeatureValue.featureValueWithDouble_(self.size)

		return None

class MarsHabitatPricerOutput(Foundation.NSObject):
	__pyobjc_protocols__ = [MLFeatureProvider]

	def initWithPrice_(self, price):
		self = objc.super(MarsHabitatPricerOutput, self).init()
		if self is None: return None

		self.price = price
		return self

	def featureNames(self):
		names = Foundation.NSSet.setWithArray_(["price"])
		return names

	def featureValueForName_(self, featureName):

		if featureName == "price":
			return CoreML.MLFeatureValue.featureValueWithDouble_(self.price)

		return None


class MarsHabitatPricer(Foundation.NSObject):

	def init(self):
		self = objc.super(MarsHabitatPricer, self).init()
		if self is None: return None

		return self

	def initWithContentsOfURL_error_(self, url, error):
		self = objc.super(MarsHabitatPricer, self).init()
		if self is None: return None

		error = None
		self.var_model, error = CoreML.MLModel.modelWithContentsOfURL_error_(url, None)

		if(self.var_model == None):
			return None, error

		return self, None


	def model(self):
		return self.var_model

	def predictionFromFeatures_error_(self, input, in_error):
		outFeatures, error = self.var_model.predictionFromFeatures_error_(input, in_error)
		result = MarsHabitatPricerOutput.alloc().initWithPrice_(outFeatures.featureValueForName_("price").doubleValue())
		return (result, error)
	
	def predictionFromSolarPanels_greenhouses_size_error_(self, solarPanels, greenhouses, size, error):
		input =  MarsHabitatPricerInput.alloc().initWithSolarPanels_greenhouses_size_(solarPanels, greenhouses, size)
		return self.predictionFromFeatures_error_(input, None)


def main():

	url = Foundation.NSURL.fileURLWithPath_("MarsHabitatPricer.mlmodelc")

	pricer, error = MarsHabitatPricer.alloc().initWithContentsOfURL_error_(url, None)

	if pricer :
		output, error = pricer.predictionFromSolarPanels_greenhouses_size_error_(4, 3, 10000, None)
		if output :
			print("OUTPUT: {0}".format(output.price))
		else:
			print("ERROR: can't get prediction: {0}".format(error.description()))

	else:
		print("ERROR: can't load pricer: {0}".format(error.description()))


if __name__ == "__main__":
	main()
