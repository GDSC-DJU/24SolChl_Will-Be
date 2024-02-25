# "Will Be"
> **Adding Hope into Education for Developmental Disabilities** 


<p align="center">
  <img src="https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/55903638/677d851f-79f7-4b76-9f88-5458d529b040">
</p>

<div style="display: flex; justify-content: space-around;">
  <img src="https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/55903638/dfb017a6-6de5-4eef-824c-6b39ff4d899c" width="31%">
  <img src="https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/55903638/cb442980-6b3f-4885-94c7-5dac5759a142" width="31%">
  <img src="https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/55903638/a4872997-cbbe-4545-8b83-7a83e2368eeb" width="31%">
</div>

Check our [more pages](./AppPreview.md)!

> [!TIP]
> 
> <table style="width:100%">
>   <tr>
>     <th colspan="6">Table of Contents</th>
>   </tr>
>   <tr>
>     <th>
>       <a href="#core-info"><b>Core Info</b></a>
>     </th>
>     <th>
>       <a href="#details"><b>Details</b></a>
>     </th>
>     <th>
>       <a href="#story"><b>Story</b></a>
>     </th>
>     <th>
>       <a href="#roadmap"><b>Roadmap</b></a>
>     </th>
>     <th>
>       <a href="#who-we-are"><b>Who We Are</b></a>
>     </th>
>     <th>
>       <a href="#credits"><b>Credits</b></a>
>     </th>
>   </tr>
>   <tr>
>     <td>
>       <ol type="i">
>         <li>
>           <a href="#what-will-be-is">Title</a>
>         </li>
>         <li>
>           <a href="#how-to-build">How to Build</a>
>         </li>
>         <li>
>           <a href="#related-sdgs">Related SGDs</a>
>         </li>
>       </ol>
>     </td>
>     <td>
>       <ol type="i">
>         <li>
>           <a href="#how-we-designed">How We Designed</a>
>         </li>
>         <li>
>           <a href="#demo-video">Demo Video</a>
>         </li>
>       </ol>
>     </td>
>     <td>
>       <ol type="i">
>         <li>
>           <a href="#what-we-want-to-solve">What we want to SOLVE</a>
>         </li>
>       </ol>
>     </td>
>     <td>
>       -
>     </td>
>     <td>
>       -
>     </td>
>     <td>
>       <ol type="i">
>         <li>
>           <a href="#used-open-sources">Used Open-Sources</a>
>         </li>
>       </ol>
>     </td>
>   </tr>
> </table>

</br>

## Core Info
### What "Will Be" is
In brief, the solution "Will Be" is a platform for making special education efficient and effective.</br>
For details of background and motivation, they are revealed in the 'Story' section.
### How to Build
**Prerequisite Installation** *(need to be accessible via CLI)*
- [Git](https://git-scm.com/)
- [Flutter  SDK](https://docs.flutter.dev/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli?hl=en#install-cli-mac-linux)

Execute the script below in the CLI shell after the prerequisites are satisfied.
```bash
git clone https://github.com/GDSC-DJU/24SolChl_Will-Be.git .
cd ./FlutterApp/WillBeApp
flutter pub get
```

> [!IMPORTANT]  
> For an appropriate launch, the Flutter app needs to be connected with Firebase.</br>
> Please follow the instructions about [Firebase CLI for Flutter](https://firebase.google.com/docs/flutter/setup?platform=android#install-cli-tools) with the testing account. 

After the connection process, and while `FlutterApp/WillBeApp/` is the shell's working directory, run the Flutter app with the command.
```bash
flutter run --release
```

### Related SDGs
| SDG | Specific Indicator | Approach | Goal Phase |
| --- | ------------------ | -------- | ---------- |
| *no.4*<br>**Quality Education** | **4.a**<br>Build and upgrade education facilities that are child, disability and gender sensitive and provide safe, non-violent, inclusive and effective learning environments for all.            |  | Phase no.2 |
| *no.10*<br>**Reduce Inequality**| **10.2**<br>By 2030, empower and promote the social, economic and political inclusion of all, irrespective of age, sex, disability, race, ethnicity, origin, religion or economic or other status. |  | Phase no.2 |
| *no.16*<br>**Peace, Justice and Strong Institutions** | **16.6**<br>Develop effective, accountable and transparent institutions at all levels.| Provide transparent communication between special education teachers and parents of children with developmental disabilities. | Phase no.3 |

[SDG Indicators — UNSD](https://unstats.un.org/sdgs/indicators/indicators-list/)


## Details
### How We Designed
#### Architecture
![architecture (1)](https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/37173651/c9f62e22-b8a2-40bb-a8b0-4a345ac4932a)
| Category          | Component           | Role                                                                     |
| ----------------- | ------------------- | ------------------------------------------------------------------------ |
| Front-End         | Flutter             | ∙ Build application that the user will use                               |
| Back-End          | Firebase            | ∙ Authenticate user<br>∙ Store data (Cloud Firestore)                    |
| Back-End          | Cloud Run           | ∙ Host HTTP server being the middleware between the user and the LLM API |
| LLM Orchestration | LangChain<br>(Dart) | ∙ Leverage LLM to get closer to the expected output                      |
| LLM               | Gemini-Pro          | ∙ Main component for understanding and generating natural languages      |
#### Database Structure

<p align="center">
  <img src="https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/55903638/ef9c03f3-7880-4fe0-ba9b-d6765ce315e4">
</p>

#### Repo Directory Structure
*// 내용 추가 필요*

### Demo Video
*// 내용 추가 필요*


## Story
### What we want to SOLVE
> *Please be aware that "Will Be" is a solution designed for the field of developmental disability education, which requires a profound understanding of the intricacies involved. The following explanation seems verbose, but we believe it's necessary to fully appreciate the value of what we want to offer.*

#### Background
When symptoms such as fever or cough emerge, myriad diseases could be at play. However, to effectively mitigate these symptoms, it's crucial to diagnose the exact illness, often requiring one or more tests. Knowing the disease allows us to formulate a precise treatment plan, enabling the patient's recovery.</br></br>
This principle holds in special education. Various challenging behaviors—such as aggression, self-injury, and defiant behavior—and even identical behaviors can stem from different causes in different students. Therefore, to address these behaviors—i.e., to reduce their frequency or duration, or to substitute them with alternative behaviors—we must understand the underlying 'function' causing them.</br></br>
Unlike in medicine, where specific diseases are linked to specific symptoms, the exact neuroscientific mechanism explaining why a person with a developmental disability exhibits certain challenging behaviors due to a specific 'function' remains unclear. Therefore, finding the 'function' requires continual experimentation, and during this process, accurate measurement of behavior frequency is essential in the field.

#### Motivation
However, despite the importance of measurement, there are many practical challenges in the special education field. One of the most significant is the difficulty of simultaneously measuring and regulating students' challenging behaviors.</br>
Effective behavior management requires constant observation and intervention. However, the simultaneous demands of observing to collect accurate data and intervening to manage behaviors can place a heavy burden on educators. They often find themselves in a catch-22 situation where focusing on measurement can cause missed opportunities for timely intervention, and vice versa.</br></br>
Moreover, the manual process of behavior measurement can be time-consuming and prone to human error, further complicating the task. These challenges can make it difficult for educators to identify the underlying 'function' causing the behaviors accurately and consistently, hindering the development of an effective intervention strategy.</br></br>
To tackle this issue, the need for innovative solutions is apparent. This is where "Will Be" steps into the picture. "Will Be" is not just a name. It's a promise for the future - a beacon of hope in the challenging landscape of special education. By leveraging IT technology, we aim to automate the process of behavior measurement. This reduces the burden on educators, increases the accuracy of data collection, and enables more effective interventions. "Will Be" is more than a solution; it's our commitment to transforming the field of special education, enhancing the educational outcomes for students with developmental disabilities, and creating a world where every student will be able to reach their full potential.


## Roadmap
<p align="center">
  <img src="https://github.com/GDSC-DJU/24SolChl_Will-Be/assets/55903638/1d35a103-98fe-4553-84da-0bd7141d40fb">
</p>


## Who We Are
*// 내용 추가 필요*
> Members of GDSC Daejeon University

- **양기택** (KeeTaek Yang)
- **한수빈** (SuBeen Han)
- **이남경** (NamKyung Lee)
- **조기홍** (GiHong Jo)

## Credits
### Used Open-Sources
- [GitHub - davidmigloz/langchain\_dart](https://github.com/davidmigloz/langchain_dart)
- [GitHub - imaNNeo/fl\_chart](https://github.com/imaNNeo/fl_chart)
