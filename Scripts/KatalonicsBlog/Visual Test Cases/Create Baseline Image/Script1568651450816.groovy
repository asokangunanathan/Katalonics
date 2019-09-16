import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import java.awt.image.BufferedImage as BufferedImage
import java.io.File
import java.nio.file.Files as Files
import java.nio.file.Path as Path
import java.nio.file.Paths as Paths
import javax.imageio.ImageIO as ImageIO
import org.openqa.selenium.WebDriver as WebDriver
import com.kms.katalon.core.configuration.RunConfiguration as RunConfiguration
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.webui.driver.DriverFactory as DriverFactory
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import ru.yandex.qatools.ashot.AShot as AShot
import ru.yandex.qatools.ashot.Screenshot as Screenshot
import ru.yandex.qatools.ashot.comparison.ImageDiff as ImageDiff
import ru.yandex.qatools.ashot.comparison.ImageDiffer as ImageDiffer
import ru.yandex.qatools.ashot.shooting.ShootingStrategies as ShootingStrategies
import com.kms.katalon.core.util.KeywordUtil as KeywordUtil
import java.text.DecimalFormat as DecimalFormat
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.cucumber.keyword.CucumberBuiltinKeywords as CucumberKW
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testobject.TestObject as TestObject
import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import internal.GlobalVariable as GlobalVariable
import com.kms.katalon.core.logging.KeywordLogger as KeywordLogger

WebUI.openBrowser('')
def browserName = DriverFactory.getExecutedBrowser().getName()
//Default Ashot parameters (Default for Desktop)
int scrollTimeout = 100
int header = 0
int footer = 0
float dpr = 2

// ---------------------------------------------------------------------------------
if (browserName == 'IOS_DRIVER'){
	//Ashot parameters if Browser is on IOS:
	scrollTimeout = 500
	header=69
	footer=0
	dpr=2
}
if (browserName == 'ANDROID_DRIVER'){
	//Ashot parameters if Browser is ANDROID_DRIVER:
	scrollTimeout = 500
	header=0
	footer=0
	dpr=3
}
// ---------------------------------------------------------------------------------
// Open browser and navigate to component page
// ---------------------------------------------------------------------------------

if (browserName != 'IOS_DRIVER' && browserName != 'ANDROID_DRIVER'){
	WebUI.maximizeWindow()
}
//WebUI.setViewPortSize(1024, 768)
def theComponentURL = (GlobalVariable.envURL1 + componentLocation) + "/" + componentName + GlobalVariable.appendToURL
WebUI.navigateToUrl(theComponentURL)
WebUI.waitForPageLoad(5)
WebUI.delay(6)
// ---------------------------------------------------------------------------------
// The following is for logging info regarding the test
// ---------------------------------------------------------------------------------
KeywordLogger log = new KeywordLogger()
log.logInfo('Component Name: ' + componentName)
log.logInfo('actual URL: ' + theComponentURL)

// ---------------------------------------------------------------------------------
// Take screenshot to create the base line image and close browser
// ---------------------------------------------------------------------------------

File baseLineFile = resolveScreenshotFile((("$browserName" + '_') + "$componentName") + '_baseLine_component_page.png' //****** Variable ****
	)
takeEntirePage(DriverFactory.getWebDriver(), baseLineFile, 500, scrollTimeout, header, footer, dpr)
WebUI.comment(">>> wrote the baseLine component page image into ${baseLineFile.toString()}")
WebUI.closeBrowser()

// ---------------------------------------------------------------------------------
// Functions that help
// ---------------------------------------------------------------------------------
void takeEntirePage(WebDriver webDriver, File file, Integer timeout = 300, scrollTimeout, header, footer, dpr) {
	Screenshot screenshot = new AShot().shootingStrategy(ShootingStrategies.viewportRetina(scrollTimeout, header, footer, dpr)).takeScreenshot(
		webDriver)

	ImageIO.write(screenshot.getImage(), 'PNG', file)
}

File resolveScreenshotFile(String fileName) {
	Path projectDir = Paths.get(RunConfiguration.getProjectDir())

	Path reportDir = projectDir.resolve(baseLineImageFolder)

	Files.createDirectories(reportDir)

	Path pngFile = reportDir.resolve(fileName)

	return pngFile.toFile()
}
