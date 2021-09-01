import 'package:fim_dos_tempos_weekly/models/models.dart';

class Mocks {

  static List<Act> database() {
    var acts = List<Act>.empty(growable: true);
    var act_1 = Act(0,
                    "Ato 1",
                    [
                      Chapter(0,
                              "Tragam-me a Cabeça de Bartram Zonnar, parte 1",
                              [
                                Paragraph(0,
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed consectetur enim. Morbi vestibulum commodo ex, ac placerat ex faucibus id. Maecenas finibus nisi quis tristique consequat. Sed id placerat diam. Quisque in convallis neque. Ut convallis facilisis vehicula. Donec fermentum volutpat purus, ut pellentesque libero cursus eget. Sed sem nulla, vulputate id enim nec, pellentesque dapibus metus. Vivamus at mi ut urna pretium egestas eu vitae arcu. Vestibulum malesuada, nibh id eleifend mattis, dui nibh blandit lorem, at auctor nulla risus in odio. Phasellus accumsan eget libero at dictum. Curabitur in mi augue. In a tincidunt massa. Proin eget sem sit amet lorem molestie porttitor. Nunc dignissim mi id sapien ultricies tempor. Nunc quis fermentum lorem."),
                                Paragraph(1,
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed consectetur enim. Morbi vestibulum commodo ex, ac placerat ex faucibus id. Maecenas finibus nisi quis tristique consequat. Sed id placerat diam. Quisque in convallis neque. Ut convallis facilisis vehicula. Donec fermentum volutpat purus, ut pellentesque libero cursus eget. Sed sem nulla, vulputate id enim nec, pellentesque dapibus metus. Vivamus at mi ut urna pretium egestas eu vitae arcu. Vestibulum malesuada, nibh id eleifend mattis, dui nibh blandit lorem, at auctor nulla risus in odio. Phasellus accumsan eget libero at dictum. Curabitur in mi augue. In a tincidunt massa. Proin eget sem sit amet lorem molestie porttitor. Nunc dignissim mi id sapien ultricies tempor. Nunc quis fermentum lorem.")
                              ],
                              "https://www.youtube.com/watch?v=saqvz-gIGDs"),
                      Chapter(1,
                              "Tragam-me a Cabeça de Bartram Zonnar, parte 2",
                              [
                                Paragraph(0,
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sed consectetur enim. Morbi vestibulum commodo ex, ac placerat ex faucibus id. Maecenas finibus nisi quis tristique consequat. Sed id placerat diam. Quisque in convallis neque. Ut convallis facilisis vehicula. Donec fermentum volutpat purus, ut pellentesque libero cursus eget. Sed sem nulla, vulputate id enim nec, pellentesque dapibus metus. Vivamus at mi ut urna pretium egestas eu vitae arcu. Vestibulum malesuada, nibh id eleifend mattis, dui nibh blandit lorem, at auctor nulla risus in odio. Phasellus accumsan eget libero at dictum. Curabitur in mi augue. In a tincidunt massa. Proin eget sem sit amet lorem molestie porttitor. Nunc dignissim mi id sapien ultricies tempor. Nunc quis fermentum lorem."),
                                Paragraph(1,
                                          "e arius pega fogo...")
                              ],
                              "https://www.youtube.com/watch?v=saqvz-gIGDs")
                    ]
    );
    acts.add(act_1);
    acts.sort((a, b) => a.index );
    return acts;
  }
}