#lang racket

(require racketscript/htdp/image
         racketscript/htdp/universe
         racketscript/interop)

;; Ported from Jens Axel Søgaard's implementation. https://github.com/soegaard/flappy-bird

;;; COLORS
(define sky-color   (color 0 197 255))
(define grass-color (color 0 239 112))

;;; Preload Images

(define IMAGE-CACHE
  ($/obj
    ["http://i.imgur.com/pVIa8X8.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABIElEQVQokWP8//8/AzYQbOGOVWLtiZ2M6GIsuDQzz9wKF/ub7s2w4vAWuDyGQf///4fjIHO3/6EXfv8PvfD7v9fBH/+9Dv74H2Tu9v/Xr18oOMjc7T+yPiaY6TAX/E33Zvj68S+KRXdeX4KzI2x9GFYc3oLiXZZgC/f/MKciK/zRtQlrWGEDTNgEVxzewsBR5sfAwMDA8KNrE0NNUBXcNegWMjBAA5bpXifDP6VyhMn3OlEUQQzyw9AMC2TG////MwRbuP9ftdAWLhkWfxjFOxxlfgyTNF9g9UredQkGRlg6QQ6o9zndcEWCU0oZJmm+YMi7LoHVkLUndjKipBNkzchieVCDsLmCgYEB4RJk12AzTHBKKVZXYBiCbhg2DdgAALoBpthRKuBdAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/pVIa8X8.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABIElEQVQokWP8//8/AzYQbOGOVWLtiZ2M6GIsuDQzz9wKF/ub7s2w4vAWuDyGQf///4fjIHO3/6EXfv8PvfD7v9fBH/+9Dv74H2Tu9v/Xr18oOMjc7T+yPiaY6TAX/E33Zvj68S+KRXdeX4KzI2x9GFYc3oLiXZZgC/f/MKciK/zRtQlrWGEDTNgEVxzewsBR5sfAwMDA8KNrE0NNUBXcNegWMjBAA5bpXifDP6VyhMn3OlEUQQzyw9AMC2TG////MwRbuP9ftdAWLhkWfxjFOxxlfgyTNF9g9UredQkGRlg6QQ6o9zndcEWCU0oZJmm+YMi7LoHVkLUndjKipBNkzchieVCDsLmCgYEB4RJk12AzTHBKKVZXYBiCbhg2DdgAALoBpthRKuBdAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/iDV4WCk.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABGklEQVQokWP8//8/AzYQbOGOVWLtiZ2M6GIsuDQzz9wKF/ub7s2w4vAWuDyGQf///4fjIHO3/6EXfv8PvfD7v9fBH/+9Dv74H2Tu9v/Xr18oOMjc7T+yPiZkFzDP3Mrw9eNfhq8f/6JYdOf1JTg7wtaHYcXhLSjeZYEZ8KNrEwMDmmZiAeP///+xBuKPrk1wNkeZH0PLujYGFVE9FBfBwoYxyNztPyzQkEGErQ+GQdjA2hM7GVkYGBgYmO51MvxTKodLMN3rRFHIUebHMEnzBVZDgi3c/+P0zvucbgYGBgYGwSmlDJM0XzDkXZfA6RJGWGILtnD/D9OIDmAGoYO86xKohsAMQnYFukHYXMHAAI0ddIDNe9iSOwwAADYFpi2znNMKAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/wXdjiq4.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABH0lEQVQokWP8//8/AzYQbOGOVWLtiZ2M6GIsuDQzz9wKF/ub7s2w4vAWuDyGQf///4fjIHO3/6EXfv8PvfD7v9fBH/+9Dv74H2Tu9v/Xr18oOMjc7T+yPiZkFzDP3Mrw9eNfhq8f/6JYdOf1JTg7wtaHYcXhLSjeZYEZ8KNrEwMDmmZiARMhBT+6NjHUBFXBXQMLG2TA+P//f6wx8aNrEwqfo8wPqyVrT+xkZAwyd/u/aqEtwz+lcoTz7nUyhMUfhhvEUebHMEnzBVZD8q5LQMIE2QAGBgaGsPjDDO9zuhkYHt1kEJxSyjBJ8wVD3nUJnC5BSScwF7zP6YaLvc/pZsiDGoTNFQwMOMIE2RAYEJxSitUVcEPQAbaAxpbcYQAAfeSksBydkGsAAAAASUVORK5CYII="]
    ["http://i.imgur.com/uQmLRfi.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABF0lEQVQokXVSoW7DMBB9rsoLKlUq3icUJGQ0kaYhh1RBJaEDhdWAP6AaKC0ZykLKolYtDSkeKVmlsUmdAsoqg93I7NjJ7aQj7+69e3e2ICJwkYQxW9gc96KN9f8jF6+RxaazA4qqtPWOEBHZlEFE+rQkfVrSbTeh225CMohIa+2lDCJyeT2jbhxMZwf8fL55gz6+3xtX948oqtJbt5+EMRmrbmOuavZWXPQ4sKhKpGoIAMhVjWe5sG7aAwFz2PMKuHtq0PPKa8pVjVQuOmRzZEFESMKY2q/hrpOqIdaDC7tKdh1BmH/iHurl4cs2zbdjrAcXZNcRK7I57oX3T1yyi2V/QpwLAI0T1w0nNt+OWRcdkbYYR+DiF4oPpLLgN2ePAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/SU2S3ZY.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABE0lEQVQokWP8//8/AzYQbOGOVWLtiZ2M6GIsuDSvWOAGF4tI2MWw4vAWuDyGQf///4fjIHO3/7+u9/z/db3n/4/txv9/bDf+H2Tu9v/Xr18oOMjc7T+yPiZkF6xY4Mbw78Fyhn8PlqNYdOf1JYSrbH0YVhzeguJdJpgByxreYmgmFjD+//8fayAua3gLZ0c1CDO0rGtjUBHVQ3ERLGwYg8zd/sMCDRlE2PpgGIQNrD2xkxESO3cnMTAo5yFk7k5CURjVIMwwm/8VVkOCLdz/4/ROn9dzBgYGBoaibZIMs/lfMaR+FMPpEkZYYgu2cP8P04gOYAahg9SPYqiGwAxCdgW6QdhcwcAAjR10gM172JI7DAAAYSGlcmAxso8AAAAASUVORK5CYII="]
    ["http://i.imgur.com/N4ExsGu.pngg" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAABF0lEQVQokWP8//8/AzYQbOGOVWLtiZ2M6GIsuDSvWOAGF4tI2MWw4vAWuDyGQf///4fjIHO3/7+u9/z/db3n/4/txv9/bDf+H2Tu9v/Xr18oOMjc7T+yPiZkF6xY4Mbw78Fyhn8PlqNYdOf1JYSrbH0YVhzeguJdJpgByxreYmgmFjARUrCs4S1DTVAV3DWwsEEGjP///8caE8sa3qLwoxqEsVqy9sRORsYgc7f/Kxa4MTAo5yFk7k5iiEjYBTcoqkGYYTb/K6yGpH4Ug0YxsgEMkCjt83rO8OIUA0PRNkmG2fyvGFI/iuF0CWo6gbqgz+s5XKjP6zlDKtQgbK5gYMARJsiGwEDRNkmsroAbgg6wBTS25A4DAMz0ohYJTAAAAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/ET8w2Al.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAAA/klEQVQokXWSoQvCQBTG38nAuCBbWjSbh2BeMW1FFgf7J4awE8R/QjCOFU0r5sEwC7ZFk8OwaJBn0Dt3t7cvvnff77737hgiAqXA9cjG8XJmes0YMh/mjaxFlQV5Wci+DmLdJIHroTC/b9963NoSILRaLJVEI2EWCaLKkgChurkqgLwslHGNwPWQumlvPvRJBzWiinlZQNzaAACwNx+w9hOZRr8Q4LfYurnC1JqR8QUo9pOeWSyZISIErofb0042136ijBO3NmT8SY4S8sn/dbqL2ozv8lD6ciDjTwj5hIQcL2em/JOuuVsLuUMmEeDePxmCpS+HTNGD6DDKQOkDZwyBlHb3OmkAAAAASUVORK5CYII="]
    ["http://i.imgur.com/oWNNQjG.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAAA8klEQVQokY2SoQoCQRCG/5UD4wXRZDRbPYSrXjF5RYyCLyGC53McGMVis5gFMQvXjKYTg9FwjEFm2B1X8IMLN8N8/LO7hojgI40Sb2N3PhhdC34Nr/t3qU1PTWyPe+lrkbGTpFFCPFwVn/rs2RIBM46HTqKaFlQFiYC53i+OYHvcO+sGLMjDElXxfQb/IElmz5bzMXlYYjGaSxq9GgCYUW9AvsY4HiIPS/m3xTa788EEwGfnTrMrDfsMWLDJHl5JGiVkiMj7Jlb1GwBg+Wpjkz0wyRo/k8gVp1FCPKhhkWaSNVwJi+wUWuRLAajHpmW+AR9vq32E9yRwdKYAAAAASUVORK5CYII="]
    ["http://i.imgur.com/Bafdbfg.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAMCAYAAACEJVa/AAAA/klEQVQokY2RIQvCUBSFz2RgXBCXFs3mIZhXTFsRo7A/MQQniH9iYBSLJotZEPNgbVEMG4Y1DeMZ9F325h162jv33e+de58mhAAnz3bYwu5y1Oqe3tS8HuTkTc9dbE8HqtdBWjWJZztCNpfJ2/cLkwBS4+FISdSqA8pEEEAqzWMFsD0dlHF1CYiMDGXyvYN/1Pp1ITIyzNyA0tRHAz474X4iMjLl7Bcm+8juctR0z3bEcr9Cr9unQprH8N2AQH5hYhPeWYhnO0IHoAAAYOYGWLSvuD2A+dPCJrxjEnaak1SNNI8JILVoXzEJLTaJBLM7qUKk5k+LTUEQbs6mBk4v+lh/cxw0xHQAAAAASUVORK5CYII="]
    ["http://i.imgur.com/yHIUEuc.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAS0lEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMDBAGmDupZ0NI1IDvqQyCP3ASEp+YGBgYGB68/wpIykaAMQOD2CaQl4vAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/KP1KQtf.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAASCAYAAABmQp92AAAASUlEQVQokWMUlpD6z4ADvHn+lJFRWELq/5vnTzEkRSSlGRgYGBiYcOmGASopgNmHVcGb508Z6eCG4a+ABcbAFdxMDAyQhIHLBABUXg5oPuSSCAAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/VpPF0jb.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAXklEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMEB7DSwMDAj3IQNc/mLBJ0kVJw1CDSzYBLGFGl4N2EJtECcNRlLyAwMDAwPTm+dPGUnRAAAkjBVoFyECQgAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/ieRCFUV.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAU0lEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMEB7DSwMDAj3IQNc/mLBJ0kVJw1CDSMylBhJyQ8MDAwMTG+eP2UkRQMAa78X2DZ39yQAAAAASUVORK5CYII="]
    ["http://i.imgur.com/zVCiCnK.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAXElEQVQokWMUlpD6z0AkePP8KSODsITUf3SAS0xYQuo/E7Gmw8CoBrI1vHn+lMY2UFUDCwMDA4OIpDSGBC5/ML15/pSRZBvQNYlISuNM8iy4JLA5k4EBdzzgdCYA5jI4hzY59JEAAAAASUVORK5CYII="]
    ["http://i.imgur.com/00CqNWO.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAXElEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMEB7DSzYBGHuJVoDtkAYxJ4mL5SwhQqu2GfBJ0kVJ9FeAyMp+YGBgYGB6c3zp4ykaAAAV78VaNmvtHEAAAAASUVORK5CYII="]
    ["http://i.imgur.com/nr1fdGA.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAWElEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMEB7DSzYBGHuJVoDtkAYxJ6mjgZ8oYRVA76kMgg9zUhKfmBgYGBgevP8KSMpGgDEqhKsOPkFrgAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/MNpHT47.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAXElEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMDBAGmDupZ0NVNXAwsCA380YNrx5/pSRZBvQNYlISuNMLoMwlMgLVmwAV1BjtQFfUAMAHDwStAMW/IwAAAAASUVORK5CYII="]
    ["http://i.imgur.com/zdjz8aN.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAATklEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMDBAGmDuJVoDvkAYKp4mWcNwDyVGUvIDAwMDA9Ob508ZSdEAACGPEmDEHBW5AAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/eWHJXLh.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAASCAYAAABvqT8MAAAAW0lEQVQokWMUlpD6z0AkePP8KSOjsITU/zfPnxJULCIpzcDAwMDARKzpMDBAGmDuJVoDvkAYKp7GB1gYGLCHCi6Ps+CTpIqTaK+BkZT8wMDAwMD05vlTRlI0AAC0lRUcamBxGAAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/bF5MneC.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAABy0lEQVQ4jZ2VP2rDMBTGP6fJAbJ0DGRIMblFoYvIkDM4EHwID3lDfQeHgnsKo6UQZwnuBYKhARFvzZahszq0EpKs2KUfGBL9+b1Pz0/PgZQSXUqJvAsSoqBr37APmBD1zXsDBK5jF3hpGi/4fjJR6+ENIKXUz/NmI5U+z+c/PUq/ezVLO06JZELkdSiE8LqeTqfWCVIi7dzKsQtVwGNde8EmvGXITIF5xKosZZ5lMs8yaSrPMr0mzzJZlaWVFpUS7diMKITAsa4RxbE1V3COBWN63YIxFJxr5ybjbgTIhAhf16sePFQVojjGpWms8Y/TCaPhEOPx2Ap0qCo8zGYAALZcIiWigeu24FxD/yO1b9A16WrBGI51rV+qmRa3cqyqUJMqbybQ/F1w3qoU9V9VydCdXDCmb5Vyb7409wWaKji3wUIIPWBC1eJ5GOpKMSvBVRTHeN/vf8AJUZASybVxi0yn8zDUY/MwvOm44ByXpsHbboeEKNCpEEIgimO8brdeNy68yy0Au1esV6tWKnyB1MVxT/iS5/5e4Ws2tyCu3L1WP06J5NPjIwC7c3VJAVVuvWAFB4C+ACYQaDf6FvhWAFe3gL1gN4Crvo/pN6kep0eo0l6RAAAAAElFTkSuQmCC"]
    ["http://i.imgur.com/PbCUFF8.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAABk0lEQVQ4jZ2VwUrDQBCG/9QGS0CDx0JBoYccPKS+gKcW36EP46EP4zuU9uTBq/aQQw8VC4FcBIkBSZGwnmaYnWw24H9qO7vf/Jn9uwmMMfBpvUqdCx4ed4FvX9AFJuBiOXPWN09v3gYtsAaesqMTfH577W1ggder1PQBfQ0knMEEdQGrsnFCL+Izq4GED+VCDSVg+fPb6Zjgem9gjHG6rcqGgdN5wr8ftntMxiMAQF7UiKOQ4dI1O3ZBCUi1vKgZCgCT8Qh5UbNzyRjIAyMR9JQdO8cjG8lRLZYzrFepGWi3eVEz9D+ifQNfUYvckWs5Fp0cKxVUpLlJoPycF3UrKfSdDnKoi5PxiENP7uWh6QOUyovaBldlY0VGL46jkJMik6A1nSf4fHkHIHJ8n17xwUmncRS2HtnlmJ7kefdl57gqG0znCQ7bvdMNKY5Cp2Pplh0DYNd6FK5G8p9IOmVHdgu4UqGi1gXR0nFrXZt3N5cA7JvLJwK+fny7r00JB4C+BhII9Fz0vgZaXcBesG6g1fcy/QNhEz1w9HfK4wAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/fSZ18xk.png" "data:png;base64,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"]
    ["http://i.imgur.com/g71Gn0k.png" "data:png;base64,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"]
    ["http://i.imgur.com/QMI5uVM.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAKgAAAA4CAYAAABpLbP3AAABEklEQVR4nO3YoU0EURhGUd4LCX1gSFYQJCWswG4jNLAF0AhVUMYGLE0gwQ+DWDHhQs6Rk2+SX1z1xuF+/3kBUeP940mgZI3Hl9vVQHc3u9UfTm+n1e/29lvsZ+kYe/vl/lugf+l4+/+/n+eMtz7G3n65n+eMtz7G3n65n6Vj7O2XZukYe/ulcTheewcla7w+PwiUrMuru/1v3wA/Wn2ohwqBkiZQ0gRKmkBJEyhpAiVNoKQJlDSBkiZQ0gRKmkBJEyhpAiVNoKQJlDSBkiZQ0gRKmkBJEyhpAiVNoKQJlDSBkiZQ0gRKmkBJEyhpAiVNoKQJlDSBkiZQ0gRKmkBJEyhpAiVNoKQJlDSBkiZQ0gRK2heNjzDLzliS4wAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/HatNlYr.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAFwAAAAZCAYAAAC8ekmHAAAChElEQVRoge1ZMXLjMAyEMuqvzgfcp4t/cL7qmliXHyQvyhMyp0qV9ASVqi8fUK0X8BrDoWkABEjKcWa8M5yxJRJYLkkAkirnHCD2293nHwHtOFSxPjFboY2SvnNh5W4ZC845cM7B0+NPp8GhH8SaZI+yUdp/TrNyt4ytcVXacQAAgNePZ3Zx3jbv4ipSKx/aQxscYv7bcUC+Fcel1CmwcteMrbVih8AxPnwh1sDrx/OJ6F/FIwc1/kgR2x9D7b41gKJbeWhyhJa3Nt9QqLkb87ScX9zQk8T/4e6T4O1QcZLztMD9w4+z61oe7ThU/ikW+GgXJdZFBCt41/TsIO40+JOVgPf3212UYNf0or8YD03IDE+MBCo2W2I9K7jWIXWfIhGOtySgHB7a/JSSx1IgCq5ZOe7IXxoSD62Ia4sNAHCXa0AKPZcEx+OaxAYoIDiHeVrIxMtd51BaCK1vC0cLVhO8a3py13HXLwWt77U4mpNmCG4H7rc7NutrqhMO87QAbPQ8vgpnJ+TAOVvwS2KelqvJGQhuoTmeRQTnVpODpQ73ERPbyiMFuVUZK7jliFp2Xak6PJVHbtXSNT38/vsrKjpXUh+TZm72PjwaH5vVLgd/YfxJaHhY/Ft4dk1/rLas8zsKjka0zii041Bhs9rVAkWP8bD61/bDhcRqy5pTav/lDh4XFptPcif9iFgZtcvEVyoOc7FZ4lFkXkw/qQKT5gEAyV981F9CtF9PtP6tPHLnRfXDvi///pBNGlu5hG+aHLhXrZJd6zvrFB6l7AY+yMSKpStXgZ0IfoMOGKpCwf3nhEPYOduA3+rB59oQxumY2AA3wbNAVSiS2AA3wZPBxejYJ8P/QgVXgWpk/QMAAAAASUVORK5CYII="]
    ["http://i.imgur.com/qGrJwLb.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAAAVCAYAAAC5d+tKAAACD0lEQVRYhd1ZPXrDIAyV+3nL0rk+RNdm6lofoJ7TkzmzL8DsybMPUc9eMtMhISEEwQPiv77v8xBQpCckJGwyKSUpVPvy9sOBphMZIrcWuPxa3BcpJUkp6fvjSyK4yNFWHp9fS/uTE50zpOkEERGdjiUbrN1BzJMVF6Rmrs+v3UFQ0wklB++EZ+6oHF38uaHzcsyzziJ+nY5lcBBSeZnIdTIo0F6Rgmdlrs8vFQQizK8QXoi+nJsY28Fi4J7EFKj2N8d8mRuDsR3o9fPtYTzEJ4SXb6dcZPgAFHVvHUd7RUw5UxmEIqZ+F3Vv5WaO2XxAg677wK2D0vUCaTQwVa/Q9SKlYwmE8EI4sjvApmDuU9AWwJU0FME7YOrM823ZtYEr1eg6RZUgHbZmHSKH/n/rGNvh7lFIDgCXAagc+v/fn3eY0xpR1P3do+DsAWtCSp2dEoHvTw9jmwnAf4F5ZN5UAMx+oV4M57LN2UvhxQYA3VpznsfRfuFCjF9jOzhtp/C6BgA9z6aee1Fwdmx1NEaPPu/KWHPxEV4hb/PXU1BR99CREJVLhctO04lMf2L1+DJbn1cL7OPl4mJDrr7aNZ2gou6dxz2VKYicrS5yH/i4GmraCamtiF9mZnPz1b506rPxgvsCenNk3CBNDs5O6A0WeCPmm/fqU3IufTbumYy4E14aoVs9xS+bLU4fcgdg6vsD6AoHrocGZyYAAAAASUVORK5CYII="]
    ["http://i.imgur.com/pqBoEML.png" "data:png;base64,iVBORw0KGgoAAAANSUhEUgAAAFkAAAAYCAYAAACRD1FmAAABrklEQVRogeVZsZKEIAxF5z7Ka7Z2m+28Zr/PxtLG3sZ/suGqzHlMgIcJLI5vhsIVkpcQkyw01lpD+Pl+/j0AmLalSZlfEjFbcnD36rTWGmutGbre7vvODu7d0PWW1tY4Qvbk4u/zU0s7MK6z9sZWjXGdk7/cs2jv6GBCKUd/5VagjRxO4WRq5mzWye/HK0nIWcOPhoRkuAa7X9778WJ/c8HN88lL4RWzn3UyQvhIIpRufIYdyRFZdF4phGwjnyDpVpQupPmc1sYiAZ2H6kOA2Iba38JaGWgVTFROyQKN6EL5XK7w5UBqDUqFKJJdoGS150kxrvO/EeJDw/eeg0p3cQdIfKIayZ8Cmhs1gmfalia1y/HmZLSHvRPOtpCqkazdJcR61FTk7k588i+bLq5UN0RO1jI0tdugzzZW7bX0SteLI7kUUdfB0r/YUt7HjY6hGbqeLWpI4Zu2pUGKYuwshOQg847PyNlCCCh/n37iEFsnjmRpRKHrtQ+HtORBcj5xDcRd/Zy54vJdMQ1dX9X12GW7Cx/c3F0DihwQ5Tyr4NbU5GBjLtwn+1Cbg40x5hd2fBV6j5RVhgAAAABJRU5ErkJggg=="]
    ["http://i.imgur.com/yzgchHp.png" "data:png;base64,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"]
    ["http://i.imgur.com/q82zRS9.png" "data:png;base64,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"]))

(define (bitmap/url url)
  (bitmap/data ($ IMAGE-CACHE url)))

;;; IMAGES

(define blue-bird-images   (list (bitmap/url "http://i.imgur.com/pVIa8X8.png")
                                 (bitmap/url "http://i.imgur.com/iDV4WCk.png")
                                 (bitmap/url "http://i.imgur.com/wXdjiq4.png")))
(define red-bird-images    (list (bitmap/url "http://i.imgur.com/uQmLRfi.png")
                                 (bitmap/url "http://i.imgur.com/SU2S3ZY.png")
                                 (bitmap/url "http://i.imgur.com/N4ExsGu.pngg")))
(define yellow-bird-images (list (bitmap/url "http://i.imgur.com/ET8w2Al.png")
                                 (bitmap/url "http://i.imgur.com/oWNNQjG.png")
                                 (bitmap/url "http://i.imgur.com/Bafdbfg.png")))
(define digit-images       (list (bitmap/url "http://i.imgur.com/yHIUEuc.png")
                                 (bitmap/url "http://i.imgur.com/KP1KQtf.png")
                                 (bitmap/url "http://i.imgur.com/VpPF0jb.png")
                                 (bitmap/url "http://i.imgur.com/ieRCFUV.png")
                                 (bitmap/url "http://i.imgur.com/zVCiCnK.png")
                                 (bitmap/url "http://i.imgur.com/00CqNWO.png")
                                 (bitmap/url "http://i.imgur.com/nr1fdGA.png")
                                 (bitmap/url "http://i.imgur.com/MNpHT47.png")
                                 (bitmap/url "http://i.imgur.com/zdjz8aN.png")
                                 (bitmap/url "http://i.imgur.com/eWHJXLh.png")))

(define silver-coin-image (bitmap/url "http://i.imgur.com/bF5MneC.png"))
(define gold-coin-image   (bitmap/url "http://i.imgur.com/PbCUFF8.png"))
(define pipes (list (bitmap/url "http://i.imgur.com/fSZ18xk.png")
                    (bitmap/url "http://i.imgur.com/g71Gn0k.png")
                    ))
(define green-bottom-pipe-image (first pipes))
(define green-top-pipe-image    (flip-vertical green-bottom-pipe-image))
(define red-bottom-pipe-image   (second pipes))
(define red-top-pipe-image      (flip-vertical   red-bottom-pipe-image))

(define foreground-image (bitmap/url "http://i.imgur.com/QMI5uVM.png"))
(define get-ready-image   (bitmap/url "http://i.imgur.com/HatNlYr.png"))
(define game-over-image   (bitmap/url "http://i.imgur.com/qGrJwLb.png"))
(define flappy-bird-image (bitmap/url "http://i.imgur.com/pqBoEML.png"))
(define day-background-image   (bitmap/url "http://i.imgur.com/yzgchHp.png"))
(define night-background-image (bitmap/url "http://i.imgur.com/q82zRS9.png"))

;;; DIMENSIONS
(define width  (image-width  day-background-image))
(define height (image-height day-background-image))
(define bird-height (image-height (first yellow-bird-images)))
(define bird-width  (image-width  (first yellow-bird-images)))
(define bird-x (/ width 4))
(define pipe-width (image-width green-top-pipe-image))

;;; PIPES

(define-struct pipe (x y color) #:transparent)

;;; STATES

(define-struct get-ready ()                                           #:transparent)
(define-struct playing   (time points pipes y velocity acceleration)  #:transparent)
(define-struct game-over (death-image)                                #:transparent)

; get-ready
;   The game is waiting for the player to get ready.
; playing
;   The game has started.
;     time     = number of ticks since game start
;     points   = number of pipes passed
;     pipes    = a list of pipes on screen
;     y        = y coordinate of bird
;     velocity = number of pixels to move bird per tick (positive is down, negative is up)
;     acceleartion = number of pixels per tick per tick to change velocity
; game-over
;   The game is over. The number of points is displayed.
;     death-image = the last image of the game, i.e. screen shot of where the payer died

(define gravity 0.5)
(define pipe-gap-size 50)

(define (random-pipe)
  (define y (list-ref (list 0 50 100 150) (random 4)))
  (define color (list-ref (list "green" "red") (random 2)))
  (make-pipe (* 2 width) y color))

(define initial-playing-state 
  (make-playing 0 0 
                (list (make-pipe width 100 "green") (random-pipe))
                (/ height 2) 0 gravity))

;;; PLAYING STATE MANIPULATORS

(define (increase-time p)
  (make-playing (+ (playing-time p) 1) (playing-points p) (playing-pipes p)
                (playing-y p) (playing-velocity p) (playing-acceleration p)))

(define (increase-points p)
  (make-playing (playing-time p) (+ (playing-points p) 1) (playing-pipes p)
                (playing-y p) (playing-velocity p) (playing-acceleration p)))

(define (set-playing-pipes p ps)
  (make-playing (playing-time p) (playing-points p) ps
                (playing-y p) (playing-velocity p) (playing-acceleration p)))

(define (set-y p y)
  (make-playing (playing-time p) (playing-points p) (playing-pipes p)
                y (playing-velocity p) (playing-acceleration p)))

(define (set-velocity p v)
  (make-playing (playing-time p) (playing-points p) (playing-pipes p)
                (playing-y p) v (playing-acceleration p)))

(define (set-acceleration p a)
  (make-playing (playing-time p) (playing-points p) (playing-pipes p)
                (playing-y p) (playing-velocity p) a))
  

;;; DRAW STATES

; draw : state -> image
(define (draw s)  
  (scale 2 (draw-unscaled s)))

; draw-unscaled : state -> image
(define (draw-unscaled s)
  (cond
    [(get-ready? s) (draw-get-ready s)]
    [(playing?   s) (draw-playing   s)]
    [(game-over? s) (draw-game-over s)]
    [else           (error 'draw "unknown state")]))

; draw-get-ready : get-ready -> image
(define (draw-get-ready g)
  (place-text get-ready-image
              (place-foreground initial-playing-state day-background-image)))

; place-get-ready-text : image -> image
(define (place-text image-with-text i)
  (place-image image-with-text (/ width 2) (* 1/4 height) i))
  
; draw-playing : playing -> image
(define (draw-playing p)
  (overlay-bird p 
    (overlay-points p
      (place-foreground p 
        (place-all-pipes p                       
                         day-background-image)))))

; draw-game-over : game-over -> image
(define (draw-game-over g)
  (place-text game-over-image (game-over-death-image g)))

; overlay-bird : playing image -> image
;   draw a bird on top of the image
(define (overlay-bird p image)
  (define t (playing-time p))
  (define y (playing-y p))
  (define bird-size (image-width (first yellow-bird-images)))
  (place-image/align (list-ref yellow-bird-images (quotient (remainder t 6) 2))
                     bird-x y
                     ; (+ y (* bird-size (sin (* (/ t 40) 2 pi))))
                     "left" "top"
                     image))

; place-foreground : playing image -> image
(define (place-foreground p i)
  (define t (playing-time p))
  (place-image/align foreground-image
                     ; works because foreground is large than background image
                     (- (- 12 (remainder t 12)) 12) (image-height i)
                     "left" "bottom" i))

; overlay-points : playing image -> image
(define (overlay-points p i)
  (place-image (points->image (playing-points p))
               (/ width 2) (/ height 8)
               i))

; digit->image : number-from-0-to-9 -> image
(define (digit->image n)
  (list-ref digit-images n))

; points->image : integer -> image
(define (points->image n)
  (cond
    [(< n 10) (digit->image n)]
    [else     (beside (points->image (quotient n 10))
                      (digit->image  (remainder n 10)))]))  

(define (place-all-pipes p i)
  (place-pipes (playing-pipes p) i))

(define (place-pipes ps i)
  (cond [(empty? ps) i]
        [else        (place-pipes (rest ps)
                                  (place-pipe (first ps) i))]))

(define (place-pipe p i)
  (place-bottom-pipe p (place-top-pipe p i)))

(define (color->top-pipe c)
  (cond
    [(string=? c "green") green-top-pipe-image]
    [(string=? c "red")   red-top-pipe-image]))

(define (color->bottom-pipe c)
  (cond
    [(string=? c "green") green-bottom-pipe-image]
    [(string=? c "red")   red-bottom-pipe-image]))

(define (place-top-pipe p i)
  (define pipe (color->top-pipe (pipe-color p)))
  (place-image/align pipe (pipe-x p) (pipe-y p) "left" "bottom" i))

(define (place-bottom-pipe p i)
  (define pipe (color->bottom-pipe (pipe-color p)))
  (place-image/align pipe (pipe-x p) (+ (pipe-y p) pipe-gap-size) "left" "top" i))


;;; EVENT HANDLERS

; handle-key-event : state key -> state
(define (handle-key-event state key)
  ; each state has its own key handler
  (cond
    [(get-ready? state) (handle-key/get-ready state key)]
    [(playing?   state) (handle-key/playing   state key)]
    [(game-over? state) (handle-key/game-over state key)]))

; handle-key/get-ready : get-ready key -> state
(define (handle-key/get-ready g key)
  ; no matter, what key is pressed, start a new game where
  ; time and points are both zero
  initial-playing-state)

; handle-key/playing : playing key -> state
(define (handle-key/playing p key)
  (define after-flap (update-physics (set-velocity (set-acceleration p 0) -100)))
  (set-acceleration after-flap gravity))

; handle-key/game-over : game-over key -> state
(define (handle-key/game-over g key)
  (make-get-ready))

;;; TICK EVENTS

; handle-tick-event : state -> state
(define (handle-tick-event s)
  (cond 
    [(playing? s) (handle-tick-event/playing s)]
    [else         s]))

; handle-tick-event/playing : playing -> playing
(define (handle-tick-event/playing p)
  (handle-collisions 
   (update-points
    (update-pipes
     (update-physics (increase-time p))))))

; update-physics : playing -> playing
(define (update-physics p)
  (define y (playing-y p))
  (define v (playing-velocity p))
  (define a (playing-acceleration p))
  (define new-v (max (min (+ v a) 5) -5))
  (define new-y (+ y new-v))
  (set-y (set-velocity p new-v) new-y))

; update-pipe : pipe -> pipe
(define (update-pipe p)
  (define x (pipe-x p))
  (define y (pipe-y p))
  (cond 
    [(< x (- (image-width green-bottom-pipe-image)))
     (random-pipe)]
    [else
     (make-pipe (- x 1) y (pipe-color p))]))

; update-pipes : playing -> playing
(define (update-pipes p)
  (set-playing-pipes p (sort-pipes (map update-pipe (playing-pipes p)))))

(define (sort-pipes ps)
  (cond 
    [(< (pipe-x (first ps)) (pipe-x (second ps))) ps]
    [else (reverse ps)]))

; handle-collisions : playing -> playing
(define (handle-collisions p)
  (cond
    [(or (bird-touches-ground? p) (bird-touches-pipe? p)) 
     (make-game-over (draw-unscaled p))]
    [else p]))

; bird-touches-ground? : playing -> boolean
(define (bird-touches-ground? p)
  (> (playing-y p) (- height (image-height foreground-image) bird-height)))

(define (bird-touches-pipe? p)
  (define pipe (first (playing-pipes p)))
  (define xmin (pipe-x pipe))
  (define xmax (+ xmin pipe-width))
  (define ymin (pipe-y pipe))
  (define ymax (+ ymin pipe-gap-size))
  (define y    (playing-y p))
  (and (> (+ bird-x bird-width) xmin)
       (< bird-x xmax)
       (or (< y ymin) (> y ymax))))
  
(define (update-points p)
  (cond
    [(= bird-x (+ (pipe-x (first (playing-pipes p))) pipe-width))
     (increase-points p)]
    [else p]))
        

;;; GAME LOOP

(big-bang (make-get-ready)
          [to-draw draw]
          [on-key  handle-key-event]
          [on-tick handle-tick-event])




