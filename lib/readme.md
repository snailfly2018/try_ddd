##层的解释：
The role of the **application** layer is to decide "what to do next" with the data.

The **domain** layer is the pristine center of an app. It is fully self contained and it doesn't depend on any other layers. Domain is not concerned with anything but doing its own job well.

The **infrastructure** layer is composed of two parts - low-level data sources and high level repositories. Additionally, this layer holds data transfer objects (DTOs).

the **presentation** layer is all Widgets 💙 and also the state of the Widgets.