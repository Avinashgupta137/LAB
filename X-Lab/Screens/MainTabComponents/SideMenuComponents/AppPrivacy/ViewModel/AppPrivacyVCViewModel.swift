//
//  AppPrivacyVCViewModel.swift
//  X-Lab
//
//  Created by IPS-161 on 20/02/24.
//

import Foundation

class AppPrivacyVCViewModel  {
    
    let htmlEngString = """
           <!DOCTYPE html>
               <html>
               <head>
                 <meta charset='utf-8'>
                 <meta name='viewport' content='width=device-width'>
                 <title>Privacy Policy</title>
                 <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
               </head>
               <body>
               <strong>Privacy Policy</strong> <p>
                             IT Path Solutions built the X-Labs app as
                             a Free app. This SERVICE is provided by
                             IT Path Solutions at no cost and is intended for use as
                             is.
                           </p> <p>
                             This page is used to inform visitors regarding our
                             policies with the collection, use, and disclosure of Personal
                             Information if anyone decided to use our Service.
                           </p> <p>
                             If you choose to use our Service, then you agree to
                             the collection and use of information in relation to this
                             policy. The Personal Information that we collect is
                             used for providing and improving the Service. We will not use or share your information with
                             anyone except as described in this Privacy Policy.
                           </p> <p>
                             The terms used in this Privacy Policy have the same meanings
                             as in our Terms and Conditions, which are accessible at
                             X-Labs unless otherwise defined in this Privacy Policy.
                           </p> <p><strong>Information Collection and Use</strong></p> <p>
                             For a better experience, while using our Service, we
                             may require you to provide us with certain personally
                             identifiable information, including but not limited to Your data is store with  AES 256-bit encryption , so no need to worry about it. The information that
                             we request will be retained by us and used as described in this privacy policy.
                           </p> <!----> <p><strong>Log Data</strong></p> <p>
                             We want to inform you that whenever you
                             use our Service, in a case of an error in the app
                             we collect data and information (through third-party
                             products) on your phone called Log Data. This Log Data may
                             include information such as your device Internet Protocol
                             (“IP”) address, device name, operating system version, the
                             configuration of the app when utilizing our Service,
                             the time and date of your use of the Service, and other
                             statistics.
                           </p> <p><strong>Cookies</strong></p> <p>
                             Cookies are files with a small amount of data that are
                             commonly used as anonymous unique identifiers. These are sent
                             to your browser from the websites that you visit and are
                             stored on your device's internal memory.
                           </p> <p>
                             This Service does not use these “cookies” explicitly. However,
                             the app may use third-party code and libraries that use
                             “cookies” to collect information and improve their services.
                             You have the option to either accept or refuse these cookies
                             and know when a cookie is being sent to your device. If you
                             choose to refuse our cookies, you may not be able to use some
                             portions of this Service.
                           </p> <p><strong>Service Providers</strong></p> <p>
                             We may employ third-party companies and
                             individuals due to the following reasons:
                           </p> <ul><li>To facilitate our Service;</li> <li>To provide the Service on our behalf;</li> <li>To perform Service-related services; or</li> <li>To assist us in analyzing how our Service is used.</li></ul> <p>
                             We want to inform users of this Service
                             that these third parties have access to their Personal
                             Information. The reason is to perform the tasks assigned to
                             them on our behalf. However, they are obligated not to
                             disclose or use the information for any other purpose.
                           </p> <p><strong>Security</strong></p> <p>
                             We value your trust in providing us your
                             Personal Information, thus we are striving to use commercially
                             acceptable means of protecting it. But remember that no method
                             of transmission over the internet, or method of electronic
                             storage is 100% secure and reliable, and we cannot
                             guarantee its absolute security.
                           </p> <p><strong>Links to Other Sites</strong></p> <p>
                             This Service may contain links to other sites. If you click on
                             a third-party link, you will be directed to that site. Note
                             that these external sites are not operated by us.
                             Therefore, we strongly advise you to review the
                             Privacy Policy of these websites. We have
                             no control over and assume no responsibility for the content,
                             privacy policies, or practices of any third-party sites or
                             services.
                           </p> <p><strong>Children’s Privacy</strong></p> <!----> <div><p>
                               We do not knowingly collect personally
                               identifiable information from children. We
                               encourage all children to never submit any personally
                               identifiable information through
                               the Application and/or Services.
                               We encourage parents and legal guardians to monitor
                               their children's Internet usage and to help enforce this Policy by instructing
                               their children never to provide personally identifiable information through the Application and/or Services without their permission. If you have reason to believe that a child
                               has provided personally identifiable information to us through the Application and/or Services,
                               please contact us. You must also be at least 16 years of age to consent to the processing
                               of your personally identifiable information in your country (in some countries we may allow your parent
                               or guardian to do so on your behalf).
                             </p></div> <p><strong>Changes to This Privacy Policy</strong></p> <p>
                             We may update our Privacy Policy from
                             time to time. Thus, you are advised to review this page
                             periodically for any changes. We will
                             notify you of any changes by posting the new Privacy Policy on
                             this page.
                           </p> <p>This policy is effective as of 2024-02-20</p> <p><strong>Contact Us</strong></p> <p>
                             If you have any questions or suggestions about our
                             Privacy Policy, do not hesitate to contact us at xlabsdemo@itpath.com.
                           </p>
               </body>
               </html>
                 
           """
    
    let htmlHindiString =  """
<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <title>गोपनीयता नीति</title>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>गोपनीयता नीति</strong> <p>
              आईटी पथ सोल्यूशंस ने एक मुफ्त ऐप के रूप में एक्स-लैब्स ऐप को बनाया है। यह सेवा
              आईटी पथ सोल्यूशंस द्वारा नि: शुल्क प्रदान की जाती है और यह उपयोग के लिए इस तरह की अनुमति के रूप में है
              है।
            </p> <p>
              इस पृष्ठ का उपयोग हमारे बारे में आगंतुकों को सूचित करने के लिए किया जाता है
              यदि कोई हमारी सेवा का उपयोग करने का निर्णय करता है तो हमारी
              गोपनीयता नीति के संबंध में नीति।
            </p> <p>
              अगर आप हमारी सेवा का उपयोग करने का चयन करते हैं, तो आप सहमत होते हैं
              इस नीति के संबंध में जानकारी का संग्रह और उपयोग। हम जो व्यक्तिगत जानकारी जुटाते हैं
              सेवा प्रदान करने और सेवा में सुधार के लिए उपयोग किया जाता है। हम उपयोग नहीं करेंगे या साझा नहीं करेंगे आपकी जानकारी के साथ
              किसी को भी इस गोपनीयता नीति में वर्णित रूप से किसी अन्य के रूप में विवरणित किया गया है।
            </p> <p>
              इस गोपनीयता नीति में उपयोग किए जाने वाले शब्दों का अर्थ समान होता है
              हमारे नियम और शर्तों में, जो कि हैं
              एक्स-लैब्स जिसके अलावा इस गोपनीयता नीति में किसी अन्य तरह से परिभाषित नहीं हैं।
            </p> <p><strong>जानकारी एकत्रीकरण और उपयोग</strong></p> <p>
              बेहतर अनुभव के लिए, हमारी सेवा का उपयोग करते समय हमें आपसे
              कुछ व्यक्तिगत जानकारी प्रदान करने की आवश्यकता हो सकती है, जिसमें से कुछ हैं, लेकिन इसका सीमित नहीं है आपका डेटा AES 256-बिट एन्क्रिप्शन के साथ स्टोर किया जाता है, इसलिए इसकी चिंता करने की कोई जरुरत नहीं है। वह जानकारी
              हम आवेदन की गोपनीयता नीति में वर्णित रूप में हमारे द्वारा रखी जाएगी।
            </p> <!----> <p><strong>लॉग डेटा</strong></p> <p>
              हम आपको सूचित करना चाहते हैं कि जब भी आप
              हमारी सेवा का उपयोग करते हैं, ऐप में एक त्रुटि के मामले में
              हम आपके फोन पर डेटा और जानकारी (तीसरे पक्ष
              उत्पादों) जिसे लॉग डेटा कहा जाता है। यह लॉग डेटा हो सकता है
              जैसे कि आपके डिवाइस इंटरनेट प्रोटोकॉल जी
              (आईपी) पता, डिवाइस का नाम, ऑपरेटिंग सिस्टम संस्करण, डिवाइस का
              सेवा का उपयोग करते समय अंक, और अन्य
              आंकड़े।
            </p> <p><strong>कुकीज़</strong></p> <p>
              कुकीज़ वे फ़ाइलें हैं जो एक छोटी मात्रा में डेटा के रूप में होती हैं जो
              आमतौर पर अनजान अद्वितीय पहचानकर्ता के रूप में उपयोग किया जाता है। ये भेजे
              जाते हैं
              आपके ब्राउज़र से उन वेबसाइटों से और होते हैं
              आपके डिवाइस की आंतरिक स्मृति में संग्रहित।
            </p> <p>
              यह सेवा इन “कुकीज़” का सीधा उपयोग नहीं करती है। हालांकि,
              ऐप किसी तीसरे पक्ष कोड और पुस्तकालयों का उपयोग कर सकता है
              “कुकीज़” जानकारी जमा करने और उनकी सेवाओं को सुधारने के लिए।
              आपके डिवाइस पर एक कुकी भेजा जा रहा है। यदि आप
              हमारी कुकीज़ को अस्वीकार करने का विकल्प चुनते हैं, तो आप शायद इस्तेमाल नहीं कर सकते
              इस सेवा के कुछ हिस्सों का।
            </p> <p><strong>सेवा प्रदाता</strong></p> <p>
              हम निम्नलिखित कारणों से तीसरे पक्ष कंपनियों और
              व्यक्तियों का उपयोग कर सकते हैं:
            </p> <ul><li>हमारी सेवा को सुविधाजनक बनाने के लिए;</li> <li>हमारी सेवा को हमारे पक्ष पर प्रदान करने के लिए;</li> <li>सेवा संबंधित सेवाओं को करने के लिए; या</li> <li>हमारी सेवा का उपयोग कैसे किया जाता है की जाँच में हमारी मदद करने के लिए।</li></ul> <p>
              हम इस सेवा के उपयोगकर्ताओं को सूचित करना चाहते हैं
              कि इन तीसरे पक्षों के पास उनकी व्यक्तिगत है
              सूचना। कारण है कि उन्हें कार्यों का कार्य करने के लिए
              उन्हें दिए गए हैं। हालांकि, वे अनिवार्य रूप से नहीं हैं
              खुलासा या इस जानकारी का उपयोग किसी अन्य उद्देश्य के लिए।
            </p> <p><strong>सुरक्षा</strong></p> <p>
              हम आपके द्वारा हमें आपकी विश्वास की कीमत देने की मूल्यवानता करते हैं
              पर्सनल जानकारी, इसलिए हम इसका व्यापार करने का प्रयास कर रहे हैं
              सौथी विकल्पनीय तरीके से इसका उपयोग करने के। लेकिन याद रखें कि कोई विधि
              इंटरनेट पर ट्रांसमिशन का, या इलेक्ट्रॉनिक की विधि
              स्टोरेज 100% सुरक्षित और विश्वसनीय नहीं है और हम नहीं
              इसकी पूर्ण सुरक्षा की गारंटी दे सकते हैं।
            </p> <p><strong>अन्य साइटों के लिंक</strong></p> <p>
              इस सेवा में अन्य साइटों के लिंक हो सकते हैं। अगर आप क्लिक करते हैं
              तृतीय-पक्ष लिंक पर, तो आप उस साइट पर निर्देशित किए जाएंगे। ध्यान दें
              ये बाहरी साइट हमारे द्वारा संचालित नहीं हैं।
              इसलिए, हम इसे मजबूती से आगे बढ़ाने के लिए आशीर्वाद देते हैं
              इन वेबसाइटों की गोपनीयता नीति। हमारा
              नियंत्रण नहीं है और किसी भी तृतीय-पक्ष साइट की सामग्री पर
              गोपनीयता नीतियों, या अभ्यासों के।
            </p> <p><strong>बच्चों की गोपनीयता</strong></p> <!----> <div><p>
                हम बच्चों से व्यक्तिगत जानकारी जानते नहीं हैं। हम
                सभी बच्चों को कभी भी किसी व्यक्तिगत
                जानकारी न देने के लिए प्रोत्साहित करते हैं
                आवेदन और/या सेवाओं के माध्यम से।
                हम माता-पिता और कानूनी परिचालकों को मॉनिटर करने की सलाह देते हैं
                उनके बच्चों की इंटरनेट उपयोग और इस नीति को प्रोत्साहित करने में मदद करने के लिए
                उनके बच्चों को कभी भी अनुमति के बिना आवेदन और/या सेवाओं के माध्यम से कोई भी व्यक्तिगत जानकारी प्रदान करने के लिए। अगर आपको किसी बच्चे का कारण है
                व्यक्तिगत जानकारी हमें आवेदन और/या सेवाओं के माध्यम से प्रदान करने का एक विषय है,
                कृपया हमसे संपर्क करें। आपको अपने देश में अपनी व्यक्तिगत जानकारी की प्रसंस्करण की सहमति देने के लिए कम से कम 16 वर्ष का होना चाहिए (कुछ देशों में हम आपकी माता
                या अपने अधिकारी को अपने बच्चे की ओर से ऐसा करने की अनुमति दे सकते हैं)।
              </p></div> <p><strong>इस गोपनीयता नीति में परिवर्तन</strong></p> <p>
              हम अपनी गोपनीयता नीति को अपडेट कर सकते हैं
              समय समय पर। इसलिए, आपको इस पृष्ठ को समय-समय पर समीक्षा करने की सलाह दी जाती है
              नियम। हम
              इस पृष्ठ पर नई गोपनीयता नीति पोस्ट करके आपको सूचित करेंगे।
            </p> <p>यह नीति 2024-02-20 से प्रभावी है</p> <p><strong>संपर्क करें</strong></p> <p>
              अगर आपके पास हमारे गोपनीयता नीति के बारे में कोई सवाल या सुझाव हैं,
              हमें mailto:xlabsdemo@itpath.com पर संपर्क करने में संकोच न करें।
            </p>
</body>
</html>
"""
}

