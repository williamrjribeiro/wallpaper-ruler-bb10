// Default empty project template
import bb.cascades 1.0

// creates one page with a label
Page {
    // SIGNAL if language selection changed
    signal languageChanged(string locale)
    id: mainPage
    Container {
        layout: DockLayout {}
        Label {
            id: lblHello
            text: qsTr("Hello World") + Retranslate.onLanguageChanged
            textStyle.base: SystemDefaults.TextStyles.BigText
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        DropDown {
            id: dpdLanguages
            // image + text + description
            title: qsTr("Language") + Retranslate.onLanguageChanged
            Option {
                text : "English"
                value : "en"
                selected : (_appSettings.getValueFor("APP_LANG","en") == "en")
                onSelectedChanged : {
                    if (selected == true) {
                        console.log ("[dpdLanguages.onSelectedChanged] English selected");
                        // SIGNAL
                        mainPage.languageChanged("en");
                        _appLocalization.loadTranslator("en");
                        _appSettings.saveValueFor("APP_LANG","en");
                    }
                }
            }
            Option {
                text : "Español"
                value : "es"
                selected : (_appSettings.getValueFor("APP_LANG","en") == "es")
                onSelectedChanged : {
                    if (selected == true) {
                        console.log ("[dpdLanguages.onSelectedChanged] Spanish selected");
                        mainPage.languageChanged("es");
                        _appLocalization.loadTranslator("es");
                        _appSettings.saveValueFor("APP_LANG","es");
                    }
                }
            }
        }
    }
}

