import subprocess 

data = subprocess.check_output(['netsh','wlan','show',
'profiles']).decode('utf-8').split('\n')

profiles = [i.split(":")[1][1:-1] for i in data if "All User Profile" in i]
 
print("\n{:<30}| {:<}".format("Wi-Fi Name", 'Password'));
print("--------------------------------------------")

for i in profiles:
     results = subprocess.check_output(['netsh','wlan',
'show','profile',i,'key=clear']).decode('utf-8',
        errors="backlashreplace").split(
           '\n')
     results = []

     for b in results:
        if "Key Content" in b:
          result.append(b.split(":")[1][1:-1])


try:
       print("{:<30}| {:<}".format(i, results[0]))
except Exception as e:
       print("{:<30}| {:<}".format(i, ""))
except Exception as e:
       print("{:<30}| {:<}".format(i, "ERROR OCCURED"))


