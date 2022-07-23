# Automatic-Smart-Shot
Automatic is a basketball shot tracker on Watch OS that uses motion sensor artificial intelligence to recognize personal jump shots. It then returns basketball related metrics to the user who can use it as feedback to train themselves. For example, if the user takes a shot with a 49 degree x-angle and misses it, and shoots with a 45 degree angle and makes it, we can tell the user where to try to put their arc. With Watch OS, we as developers can get tons of data that will come in handy with an app like this.

Apple's watch and iphone products both possess powerful motion sensor tools such as accelerometers, gyrometers, magnetometers, and altimeters that can run at up to 100 Hz. All XCode developers have access to these data points in their programs. Being that I love basketball, When I was first introduced to the idea of developing an app with this data, I thought , "Why not make an apple watch app that could track the motion of a basketball shot?".

Since then, I've dedicated most of my free time to figuring this problem out and it has been an absolute journey to say the least. Through several weeks of thinking this project out, I decided the best route to go down was machine learning. If I could feed an AI data points over periods of time, I could train it to recognize specific movements, differentiating between shots and no shots, and gathering the motion data within that the timeframe of the shot. At the time, I knew nothing about machine learning. Lucky for me, XCode comes with a free "Create ML" machine learning tool that is very easy to learn. 

After weeks of figuring the create ML out, I had finally made an AI that could vaguely recognize the motion of a basketball shot. However, there were some major flaws. 1) The AI was personalized to my jumpshot only. 2)The AI could not fully encapsulate all of the data 100% of the time. 3)The AI would sometimes not pick up on the shot movement at all. After talking these problems out with several people, I realized I was relying way too much on the algorithms of the AI and not diving deep enough into the data itself. In order to make a successful app that recognizes a shot, I first needed to figure out how the motion sensors reacted to the initiation of a shot motion, so that maybe I could find alternative ways to capture my data.

So, I retraced my steps and decided to complete my first prototype. Prototype 1 of Automatic : Smart Shot's sole purpose was to capture motion data for three seconds after a button was pressed. Then, this data would be saved to a class and exported to a csv file on the background of the xCode project. To clean up my data, I rounded all values to the nearest hundereth. This prototype allowed me to test shot movements as a developer, and to further look into how the accelerometer and gyrometer reacted when a shot motion occured. 

The main goal of the first prototype of Automatic was to take a step back and really get a good look at the data I was using to train my artificial 
intelligence. The best way I could possibly do this was to record motion sensor data, round everything to the nearest hundereth, and save it in a local 
csv file. I did not have to worry about training the AI or using the data for a greater purpose. All I wanted to do was get cleaned up motion sensor data, 
so that I could see the correlations between their fluctuations and an basketball shot motion. 

My interface was quite simple. It hosted a button that when clicked, would initiate a 3 second long sample of motion sensor recording. After that, this 
data would be saved to a csv and also be printed to the log. I could then as a developer, look at the data and see how it responds to specific movements. 
I hoped that I could use this prototype to figure out a threshold of some sorts that I could use to encapsulate my jump shot within a tight window. 

That's the simple rundown of the prototype. Now let's get down to the logic!

I was able to execute this program in roughly 260 lines of code. 

To prevent any runtime errors, I first checked if the accelerometer and device motion was available on the current user's device. If not, I would terminate
the program instead of allowing the user to record data. Once I did that, I wrote my function to record data. I knew I needed a structure to store this 
data after it was done, so I created a MotionData class at the bottom of my program. This class contained lists for all 6 data points I was collecting 
over the span of 3 seconds (acc x,y,z and gyr x,y,z). It also hosted a dictionary of these lists, which would later be used to write the data to a csv 
file in string format.

After creating the MotionData class, I used a timer on repeat to collect data and add it to the MotionData object for the next 3 seconds after the record 
button had been pressed by the user. Since my timer was running at an interval of 1/100, or 100 hZ, I made a counter to keep track of how many intervals 
had passed. Once this interval reached 300, it meant that I was at 3 seconds worth of data, allowing me to invalidate the timer and move on to the next 
step. 

After this timer was invalidated, I added functions to the MotionData class that would allow me to wrap the data into a dictionary and write it to a csv. 
This was the trickiest part of my program for sure. The wrapping function just set each key of the dictionary equal to one of the 6 lists that were 
already filled with motion data. The csv function took this complete dictionary and iterated through it, creating a string variable that contained all of 
the values in csv format. 

Example: AX, AY, AZ, GX, GY, GZ
         3.0,4.0,5.0,6.0,7.0,8.0.    This is the format of a csv. A top down table of values in one string variable.
         
 First, I iterateed through the dictionary, but only accessing the keys and not the values, so that I could make the top row of the string.
         Then, I created a nested for loop. The first loop was a simple for loop that ran 300 times, since there were 300 values in each of the lists. 
         The nested for loop, iterated through each key of the dictionary. This allowed me to print out the values in the correct format. For example, 
         the value at index 0 for all lists would be printed horizontally on the second line of the string and so on. Along the way, there were several 
         fixes to new line syntax and spaces that I had to fix, but eventually I created a string which could feasibly be converted into a csv file using 
         FileManager inside of xCode.
         
 Now, all there was left to do was write this string to a file and save it. After several google searches, I found the syntax to do this, which 
         was quite simple. 
And that's it! That is how I created the first prototype of my motion sensor artificial intelligence watch OS app. It truly allowed me to grasp 
         a better understanding of the data and was a great first step towards a minimal product😄!

