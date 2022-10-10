
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
static char *days[] = {"Sun", "Mon", "Tue", "Wed",
  "Thu", "Fri", "Sat"};

static int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	89 c3                	mov    %eax,%ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   7:	83 fa 02             	cmp    $0x2,%edx
   a:	7f 70                	jg     7c <dayofweek+0x7c>
   c:	89 c6                	mov    %eax,%esi
   e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  11:	01 ce                	add    %ecx,%esi
  13:	6b ca 17             	imul   $0x17,%edx,%ecx
  16:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  1b:	89 c8                	mov    %ecx,%eax
  1d:	f7 ea                	imul   %edx
  1f:	d1 fa                	sar    %edx
  21:	c1 f9 1f             	sar    $0x1f,%ecx
  24:	29 ca                	sub    %ecx,%edx
  26:	8d 44 32 04          	lea    0x4(%edx,%esi,1),%eax
  2a:	8d 4b 03             	lea    0x3(%ebx),%ecx
  2d:	85 db                	test   %ebx,%ebx
  2f:	0f 49 cb             	cmovns %ebx,%ecx
  32:	c1 f9 02             	sar    $0x2,%ecx
  35:	01 c1                	add    %eax,%ecx
  37:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  3c:	89 d8                	mov    %ebx,%eax
  3e:	f7 ea                	imul   %edx
  40:	89 d0                	mov    %edx,%eax
  42:	c1 f8 05             	sar    $0x5,%eax
  45:	c1 fb 1f             	sar    $0x1f,%ebx
  48:	89 de                	mov    %ebx,%esi
  4a:	29 c6                	sub    %eax,%esi
  4c:	01 f1                	add    %esi,%ecx
  4e:	c1 fa 07             	sar    $0x7,%edx
  51:	29 da                	sub    %ebx,%edx
  53:	01 d1                	add    %edx,%ecx
  55:	ba 93 24 49 92       	mov    $0x92492493,%edx
  5a:	89 c8                	mov    %ecx,%eax
  5c:	f7 ea                	imul   %edx
  5e:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  61:	c1 f8 02             	sar    $0x2,%eax
  64:	89 ca                	mov    %ecx,%edx
  66:	c1 fa 1f             	sar    $0x1f,%edx
  69:	29 d0                	sub    %edx,%eax
  6b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  72:	29 c2                	sub    %eax,%edx
  74:	89 c8                	mov    %ecx,%eax
  76:	29 d0                	sub    %edx,%eax
}
  78:	5b                   	pop    %ebx
  79:	5e                   	pop    %esi
  7a:	5d                   	pop    %ebp
  7b:	c3                   	ret    
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
  7c:	8d 70 fe             	lea    -0x2(%eax),%esi
  7f:	eb 90                	jmp    11 <dayofweek+0x11>

00000081 <main>:

int
main(int argc, char *argv[])
{
  81:	f3 0f 1e fb          	endbr32 
  85:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	ff 71 fc             	pushl  -0x4(%ecx)
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	56                   	push   %esi
  93:	53                   	push   %ebx
  94:	51                   	push   %ecx
  95:	83 ec 38             	sub    $0x38,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  98:	8d 45 d0             	lea    -0x30(%ebp),%eax
  9b:	50                   	push   %eax
  9c:	e8 2e 04 00 00       	call   4cf <date>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	85 c0                	test   %eax,%eax
  a6:	74 18                	je     c0 <main+0x3f>
    printf(2,"Error: date call failed. %s at line %d\n",
  a8:	6a 1c                	push   $0x1c
  aa:	68 80 08 00 00       	push   $0x880
  af:	68 f4 08 00 00       	push   $0x8f4
  b4:	6a 02                	push   $0x2
  b6:	e8 fd 04 00 00       	call   5b8 <printf>
        __FILE__, __LINE__);
    exit();
  bb:	e8 67 03 00 00       	call   427 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  c0:	8b 75 dc             	mov    -0x24(%ebp),%esi
  c3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  c6:	89 f1                	mov    %esi,%ecx
  c8:	89 da                	mov    %ebx,%edx
  ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  cd:	e8 2e ff ff ff       	call   0 <dayofweek>

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
  d2:	83 ec 0c             	sub    $0xc,%esp
  d5:	56                   	push   %esi
  d6:	ff 34 9d 40 09 00 00 	pushl  0x940(,%ebx,4)
  dd:	ff 34 85 20 09 00 00 	pushl  0x920(,%eax,4)
  e4:	68 87 08 00 00       	push   $0x887
  e9:	6a 01                	push   $0x1
  eb:	e8 c8 04 00 00       	call   5b8 <printf>
  printf(1, " ");
  f0:	83 c4 18             	add    $0x18,%esp
  f3:	68 90 08 00 00       	push   $0x890
  f8:	6a 01                	push   $0x1
  fa:	e8 b9 04 00 00       	call   5b8 <printf>
  if (r.hour < 10) printf(1, "0");
  ff:	83 c4 10             	add    $0x10,%esp
 102:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 106:	76 4d                	jbe    155 <main+0xd4>
  printf(1, "%d:", r.hour);
 108:	83 ec 04             	sub    $0x4,%esp
 10b:	ff 75 d8             	pushl  -0x28(%ebp)
 10e:	68 94 08 00 00       	push   $0x894
 113:	6a 01                	push   $0x1
 115:	e8 9e 04 00 00       	call   5b8 <printf>
  if (r.minute < 10) printf(1, "0");
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	83 7d d4 09          	cmpl   $0x9,-0x2c(%ebp)
 121:	76 46                	jbe    169 <main+0xe8>
  printf(1, "%d:", r.minute);
 123:	83 ec 04             	sub    $0x4,%esp
 126:	ff 75 d4             	pushl  -0x2c(%ebp)
 129:	68 94 08 00 00       	push   $0x894
 12e:	6a 01                	push   $0x1
 130:	e8 83 04 00 00       	call   5b8 <printf>
  if (r.second < 10) printf(1, "0");
 135:	83 c4 10             	add    $0x10,%esp
 138:	83 7d d0 09          	cmpl   $0x9,-0x30(%ebp)
 13c:	76 3f                	jbe    17d <main+0xfc>
  printf(1, "%d UTC %d\n", r.second, r.year);
 13e:	ff 75 e4             	pushl  -0x1c(%ebp)
 141:	ff 75 d0             	pushl  -0x30(%ebp)
 144:	68 98 08 00 00       	push   $0x898
 149:	6a 01                	push   $0x1
 14b:	e8 68 04 00 00       	call   5b8 <printf>

  exit();
 150:	e8 d2 02 00 00       	call   427 <exit>
  if (r.hour < 10) printf(1, "0");
 155:	83 ec 08             	sub    $0x8,%esp
 158:	68 92 08 00 00       	push   $0x892
 15d:	6a 01                	push   $0x1
 15f:	e8 54 04 00 00       	call   5b8 <printf>
 164:	83 c4 10             	add    $0x10,%esp
 167:	eb 9f                	jmp    108 <main+0x87>
  if (r.minute < 10) printf(1, "0");
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	68 92 08 00 00       	push   $0x892
 171:	6a 01                	push   $0x1
 173:	e8 40 04 00 00       	call   5b8 <printf>
 178:	83 c4 10             	add    $0x10,%esp
 17b:	eb a6                	jmp    123 <main+0xa2>
  if (r.second < 10) printf(1, "0");
 17d:	83 ec 08             	sub    $0x8,%esp
 180:	68 92 08 00 00       	push   $0x892
 185:	6a 01                	push   $0x1
 187:	e8 2c 04 00 00       	call   5b8 <printf>
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	eb ad                	jmp    13e <main+0xbd>

00000191 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 191:	f3 0f 1e fb          	endbr32 
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
 19a:	8b 75 08             	mov    0x8(%ebp),%esi
 19d:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a0:	89 f0                	mov    %esi,%eax
 1a2:	89 d1                	mov    %edx,%ecx
 1a4:	83 c2 01             	add    $0x1,%edx
 1a7:	89 c3                	mov    %eax,%ebx
 1a9:	83 c0 01             	add    $0x1,%eax
 1ac:	0f b6 09             	movzbl (%ecx),%ecx
 1af:	88 0b                	mov    %cl,(%ebx)
 1b1:	84 c9                	test   %cl,%cl
 1b3:	75 ed                	jne    1a2 <strcpy+0x11>
    ;
  return os;
}
 1b5:	89 f0                	mov    %esi,%eax
 1b7:	5b                   	pop    %ebx
 1b8:	5e                   	pop    %esi
 1b9:	5d                   	pop    %ebp
 1ba:	c3                   	ret    

000001bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bb:	f3 0f 1e fb          	endbr32 
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1c8:	0f b6 01             	movzbl (%ecx),%eax
 1cb:	84 c0                	test   %al,%al
 1cd:	74 0c                	je     1db <strcmp+0x20>
 1cf:	3a 02                	cmp    (%edx),%al
 1d1:	75 08                	jne    1db <strcmp+0x20>
    p++, q++;
 1d3:	83 c1 01             	add    $0x1,%ecx
 1d6:	83 c2 01             	add    $0x1,%edx
 1d9:	eb ed                	jmp    1c8 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1db:	0f b6 c0             	movzbl %al,%eax
 1de:	0f b6 12             	movzbl (%edx),%edx
 1e1:	29 d0                	sub    %edx,%eax
}
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    

000001e5 <strlen>:

uint
strlen(char *s)
{
 1e5:	f3 0f 1e fb          	endbr32 
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ef:	b8 00 00 00 00       	mov    $0x0,%eax
 1f4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1f8:	74 05                	je     1ff <strlen+0x1a>
 1fa:	83 c0 01             	add    $0x1,%eax
 1fd:	eb f5                	jmp    1f4 <strlen+0xf>
    ;
  return n;
}
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <memset>:

void*
memset(void *dst, int c, uint n)
{
 201:	f3 0f 1e fb          	endbr32 
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	57                   	push   %edi
 209:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 20c:	89 d7                	mov    %edx,%edi
 20e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	fc                   	cld    
 215:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 217:	89 d0                	mov    %edx,%eax
 219:	5f                   	pop    %edi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    

0000021c <strchr>:

char*
strchr(const char *s, char c)
{
 21c:	f3 0f 1e fb          	endbr32 
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	84 d2                	test   %dl,%dl
 22f:	74 09                	je     23a <strchr+0x1e>
    if(*s == c)
 231:	38 ca                	cmp    %cl,%dl
 233:	74 0a                	je     23f <strchr+0x23>
  for(; *s; s++)
 235:	83 c0 01             	add    $0x1,%eax
 238:	eb f0                	jmp    22a <strchr+0xe>
      return (char*)s;
  return 0;
 23a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    

00000241 <gets>:

char*
gets(char *buf, int max)
{
 241:	f3 0f 1e fb          	endbr32 
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	57                   	push   %edi
 249:	56                   	push   %esi
 24a:	53                   	push   %ebx
 24b:	83 ec 1c             	sub    $0x1c,%esp
 24e:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 251:	bb 00 00 00 00       	mov    $0x0,%ebx
 256:	89 de                	mov    %ebx,%esi
 258:	83 c3 01             	add    $0x1,%ebx
 25b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25e:	7d 2e                	jge    28e <gets+0x4d>
    cc = read(0, &c, 1);
 260:	83 ec 04             	sub    $0x4,%esp
 263:	6a 01                	push   $0x1
 265:	8d 45 e7             	lea    -0x19(%ebp),%eax
 268:	50                   	push   %eax
 269:	6a 00                	push   $0x0
 26b:	e8 cf 01 00 00       	call   43f <read>
    if(cc < 1)
 270:	83 c4 10             	add    $0x10,%esp
 273:	85 c0                	test   %eax,%eax
 275:	7e 17                	jle    28e <gets+0x4d>
      break;
    buf[i++] = c;
 277:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 27b:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 27e:	3c 0a                	cmp    $0xa,%al
 280:	0f 94 c2             	sete   %dl
 283:	3c 0d                	cmp    $0xd,%al
 285:	0f 94 c0             	sete   %al
 288:	08 c2                	or     %al,%dl
 28a:	74 ca                	je     256 <gets+0x15>
    buf[i++] = c;
 28c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 28e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 292:	89 f8                	mov    %edi,%eax
 294:	8d 65 f4             	lea    -0xc(%ebp),%esp
 297:	5b                   	pop    %ebx
 298:	5e                   	pop    %esi
 299:	5f                   	pop    %edi
 29a:	5d                   	pop    %ebp
 29b:	c3                   	ret    

0000029c <stat>:

int
stat(char *n, struct stat *st)
{
 29c:	f3 0f 1e fb          	endbr32 
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a5:	83 ec 08             	sub    $0x8,%esp
 2a8:	6a 00                	push   $0x0
 2aa:	ff 75 08             	pushl  0x8(%ebp)
 2ad:	e8 b5 01 00 00       	call   467 <open>
  if(fd < 0)
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	85 c0                	test   %eax,%eax
 2b7:	78 24                	js     2dd <stat+0x41>
 2b9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2bb:	83 ec 08             	sub    $0x8,%esp
 2be:	ff 75 0c             	pushl  0xc(%ebp)
 2c1:	50                   	push   %eax
 2c2:	e8 b8 01 00 00       	call   47f <fstat>
 2c7:	89 c6                	mov    %eax,%esi
  close(fd);
 2c9:	89 1c 24             	mov    %ebx,(%esp)
 2cc:	e8 7e 01 00 00       	call   44f <close>
  return r;
 2d1:	83 c4 10             	add    $0x10,%esp
}
 2d4:	89 f0                	mov    %esi,%eax
 2d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2d9:	5b                   	pop    %ebx
 2da:	5e                   	pop    %esi
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
    return -1;
 2dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2e2:	eb f0                	jmp    2d4 <stat+0x38>

000002e4 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2e4:	f3 0f 1e fb          	endbr32 
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	57                   	push   %edi
 2ec:	56                   	push   %esi
 2ed:	53                   	push   %ebx
 2ee:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2f1:	0f b6 02             	movzbl (%edx),%eax
 2f4:	3c 20                	cmp    $0x20,%al
 2f6:	75 05                	jne    2fd <atoi+0x19>
 2f8:	83 c2 01             	add    $0x1,%edx
 2fb:	eb f4                	jmp    2f1 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 2fd:	3c 2d                	cmp    $0x2d,%al
 2ff:	74 1d                	je     31e <atoi+0x3a>
 301:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 306:	3c 2b                	cmp    $0x2b,%al
 308:	0f 94 c1             	sete   %cl
 30b:	3c 2d                	cmp    $0x2d,%al
 30d:	0f 94 c0             	sete   %al
 310:	08 c1                	or     %al,%cl
 312:	74 03                	je     317 <atoi+0x33>
    s++;
 314:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 317:	b8 00 00 00 00       	mov    $0x0,%eax
 31c:	eb 17                	jmp    335 <atoi+0x51>
 31e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 323:	eb e1                	jmp    306 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 325:	8d 34 80             	lea    (%eax,%eax,4),%esi
 328:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 32b:	83 c2 01             	add    $0x1,%edx
 32e:	0f be c9             	movsbl %cl,%ecx
 331:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 335:	0f b6 0a             	movzbl (%edx),%ecx
 338:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 33b:	80 fb 09             	cmp    $0x9,%bl
 33e:	76 e5                	jbe    325 <atoi+0x41>
  return sign*n;
 340:	0f af c7             	imul   %edi,%eax
}
 343:	5b                   	pop    %ebx
 344:	5e                   	pop    %esi
 345:	5f                   	pop    %edi
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    

00000348 <atoo>:

int
atoo(const char *s)
{
 348:	f3 0f 1e fb          	endbr32 
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	57                   	push   %edi
 350:	56                   	push   %esi
 351:	53                   	push   %ebx
 352:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 355:	0f b6 0a             	movzbl (%edx),%ecx
 358:	80 f9 20             	cmp    $0x20,%cl
 35b:	75 05                	jne    362 <atoo+0x1a>
 35d:	83 c2 01             	add    $0x1,%edx
 360:	eb f3                	jmp    355 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 362:	80 f9 2d             	cmp    $0x2d,%cl
 365:	74 23                	je     38a <atoo+0x42>
 367:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 36c:	80 f9 2b             	cmp    $0x2b,%cl
 36f:	0f 94 c0             	sete   %al
 372:	89 c6                	mov    %eax,%esi
 374:	80 f9 2d             	cmp    $0x2d,%cl
 377:	0f 94 c0             	sete   %al
 37a:	89 f3                	mov    %esi,%ebx
 37c:	08 c3                	or     %al,%bl
 37e:	74 03                	je     383 <atoo+0x3b>
    s++;
 380:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 383:	b8 00 00 00 00       	mov    $0x0,%eax
 388:	eb 11                	jmp    39b <atoo+0x53>
 38a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 38f:	eb db                	jmp    36c <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 391:	83 c2 01             	add    $0x1,%edx
 394:	0f be c9             	movsbl %cl,%ecx
 397:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 39b:	0f b6 0a             	movzbl (%edx),%ecx
 39e:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 3a1:	80 fb 07             	cmp    $0x7,%bl
 3a4:	76 eb                	jbe    391 <atoo+0x49>
  return sign*n;
 3a6:	0f af c7             	imul   %edi,%eax
}
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5f                   	pop    %edi
 3ac:	5d                   	pop    %ebp
 3ad:	c3                   	ret    

000003ae <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 3ae:	f3 0f 1e fb          	endbr32 
 3b2:	55                   	push   %ebp
 3b3:	89 e5                	mov    %esp,%ebp
 3b5:	53                   	push   %ebx
 3b6:	8b 55 08             	mov    0x8(%ebp),%edx
 3b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3bc:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 3bf:	eb 09                	jmp    3ca <strncmp+0x1c>
      n--, p++, q++;
 3c1:	83 e8 01             	sub    $0x1,%eax
 3c4:	83 c2 01             	add    $0x1,%edx
 3c7:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 3ca:	85 c0                	test   %eax,%eax
 3cc:	74 0b                	je     3d9 <strncmp+0x2b>
 3ce:	0f b6 1a             	movzbl (%edx),%ebx
 3d1:	84 db                	test   %bl,%bl
 3d3:	74 04                	je     3d9 <strncmp+0x2b>
 3d5:	3a 19                	cmp    (%ecx),%bl
 3d7:	74 e8                	je     3c1 <strncmp+0x13>
    if(n == 0)
 3d9:	85 c0                	test   %eax,%eax
 3db:	74 0b                	je     3e8 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 3dd:	0f b6 02             	movzbl (%edx),%eax
 3e0:	0f b6 11             	movzbl (%ecx),%edx
 3e3:	29 d0                	sub    %edx,%eax
}
 3e5:	5b                   	pop    %ebx
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
      return 0;
 3e8:	b8 00 00 00 00       	mov    $0x0,%eax
 3ed:	eb f6                	jmp    3e5 <strncmp+0x37>

000003ef <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 3ef:	f3 0f 1e fb          	endbr32 
 3f3:	55                   	push   %ebp
 3f4:	89 e5                	mov    %esp,%ebp
 3f6:	56                   	push   %esi
 3f7:	53                   	push   %ebx
 3f8:	8b 75 08             	mov    0x8(%ebp),%esi
 3fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3fe:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 401:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 403:	8d 58 ff             	lea    -0x1(%eax),%ebx
 406:	85 c0                	test   %eax,%eax
 408:	7e 0f                	jle    419 <memmove+0x2a>
    *dst++ = *src++;
 40a:	0f b6 01             	movzbl (%ecx),%eax
 40d:	88 02                	mov    %al,(%edx)
 40f:	8d 49 01             	lea    0x1(%ecx),%ecx
 412:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 415:	89 d8                	mov    %ebx,%eax
 417:	eb ea                	jmp    403 <memmove+0x14>
  return vdst;
}
 419:	89 f0                	mov    %esi,%eax
 41b:	5b                   	pop    %ebx
 41c:	5e                   	pop    %esi
 41d:	5d                   	pop    %ebp
 41e:	c3                   	ret    

0000041f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41f:	b8 01 00 00 00       	mov    $0x1,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <exit>:
SYSCALL(exit)
 427:	b8 02 00 00 00       	mov    $0x2,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <wait>:
SYSCALL(wait)
 42f:	b8 03 00 00 00       	mov    $0x3,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <pipe>:
SYSCALL(pipe)
 437:	b8 04 00 00 00       	mov    $0x4,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <read>:
SYSCALL(read)
 43f:	b8 05 00 00 00       	mov    $0x5,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <write>:
SYSCALL(write)
 447:	b8 10 00 00 00       	mov    $0x10,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <close>:
SYSCALL(close)
 44f:	b8 15 00 00 00       	mov    $0x15,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <kill>:
SYSCALL(kill)
 457:	b8 06 00 00 00       	mov    $0x6,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <exec>:
SYSCALL(exec)
 45f:	b8 07 00 00 00       	mov    $0x7,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <open>:
SYSCALL(open)
 467:	b8 0f 00 00 00       	mov    $0xf,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <mknod>:
SYSCALL(mknod)
 46f:	b8 11 00 00 00       	mov    $0x11,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <unlink>:
SYSCALL(unlink)
 477:	b8 12 00 00 00       	mov    $0x12,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <fstat>:
SYSCALL(fstat)
 47f:	b8 08 00 00 00       	mov    $0x8,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <link>:
SYSCALL(link)
 487:	b8 13 00 00 00       	mov    $0x13,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <mkdir>:
SYSCALL(mkdir)
 48f:	b8 14 00 00 00       	mov    $0x14,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <chdir>:
SYSCALL(chdir)
 497:	b8 09 00 00 00       	mov    $0x9,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <dup>:
SYSCALL(dup)
 49f:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <getpid>:
SYSCALL(getpid)
 4a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <sbrk>:
SYSCALL(sbrk)
 4af:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <sleep>:
SYSCALL(sleep)
 4b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <uptime>:
SYSCALL(uptime)
 4bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <halt>:
SYSCALL(halt)
 4c7:	b8 16 00 00 00       	mov    $0x16,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <date>:
SYSCALL(date)
 4cf:	b8 17 00 00 00       	mov    $0x17,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <getuid>:
SYSCALL(getuid)
 4d7:	b8 18 00 00 00       	mov    $0x18,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <getgid>:
SYSCALL(getgid)
 4df:	b8 19 00 00 00       	mov    $0x19,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <getppid>:
SYSCALL(getppid)
 4e7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <setuid>:
SYSCALL(setuid)
 4ef:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <setgid>:
SYSCALL(setgid)
 4f7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <getprocs>:
SYSCALL(getprocs)
 4ff:	b8 1d 00 00 00       	mov    $0x1d,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <setpriority>:
SYSCALL(setpriority)
 507:	b8 1e 00 00 00       	mov    $0x1e,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <getpriority>:
SYSCALL(getpriority)
 50f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	83 ec 1c             	sub    $0x1c,%esp
 51d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 520:	6a 01                	push   $0x1
 522:	8d 55 f4             	lea    -0xc(%ebp),%edx
 525:	52                   	push   %edx
 526:	50                   	push   %eax
 527:	e8 1b ff ff ff       	call   447 <write>
}
 52c:	83 c4 10             	add    $0x10,%esp
 52f:	c9                   	leave  
 530:	c3                   	ret    

00000531 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	57                   	push   %edi
 535:	56                   	push   %esi
 536:	53                   	push   %ebx
 537:	83 ec 2c             	sub    $0x2c,%esp
 53a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 53d:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 543:	0f 95 c2             	setne  %dl
 546:	89 f0                	mov    %esi,%eax
 548:	c1 e8 1f             	shr    $0x1f,%eax
 54b:	84 c2                	test   %al,%dl
 54d:	74 42                	je     591 <printint+0x60>
    neg = 1;
    x = -xx;
 54f:	f7 de                	neg    %esi
    neg = 1;
 551:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 558:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 55d:	89 f0                	mov    %esi,%eax
 55f:	ba 00 00 00 00       	mov    $0x0,%edx
 564:	f7 f1                	div    %ecx
 566:	89 df                	mov    %ebx,%edi
 568:	83 c3 01             	add    $0x1,%ebx
 56b:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
 572:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 576:	89 f2                	mov    %esi,%edx
 578:	89 c6                	mov    %eax,%esi
 57a:	39 d1                	cmp    %edx,%ecx
 57c:	76 df                	jbe    55d <printint+0x2c>
  if(neg)
 57e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 582:	74 2f                	je     5b3 <printint+0x82>
    buf[i++] = '-';
 584:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 589:	8d 5f 02             	lea    0x2(%edi),%ebx
 58c:	8b 75 d0             	mov    -0x30(%ebp),%esi
 58f:	eb 15                	jmp    5a6 <printint+0x75>
  neg = 0;
 591:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 598:	eb be                	jmp    558 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 59a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 59f:	89 f0                	mov    %esi,%eax
 5a1:	e8 71 ff ff ff       	call   517 <putc>
  while(--i >= 0)
 5a6:	83 eb 01             	sub    $0x1,%ebx
 5a9:	79 ef                	jns    59a <printint+0x69>
}
 5ab:	83 c4 2c             	add    $0x2c,%esp
 5ae:	5b                   	pop    %ebx
 5af:	5e                   	pop    %esi
 5b0:	5f                   	pop    %edi
 5b1:	5d                   	pop    %ebp
 5b2:	c3                   	ret    
 5b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5b6:	eb ee                	jmp    5a6 <printint+0x75>

000005b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b8:	f3 0f 1e fb          	endbr32 
 5bc:	55                   	push   %ebp
 5bd:	89 e5                	mov    %esp,%ebp
 5bf:	57                   	push   %edi
 5c0:	56                   	push   %esi
 5c1:	53                   	push   %ebx
 5c2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5c5:	8d 45 10             	lea    0x10(%ebp),%eax
 5c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5cb:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5d0:	bb 00 00 00 00       	mov    $0x0,%ebx
 5d5:	eb 14                	jmp    5eb <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5d7:	89 fa                	mov    %edi,%edx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	e8 36 ff ff ff       	call   517 <putc>
 5e1:	eb 05                	jmp    5e8 <printf+0x30>
      }
    } else if(state == '%'){
 5e3:	83 fe 25             	cmp    $0x25,%esi
 5e6:	74 25                	je     60d <printf+0x55>
  for(i = 0; fmt[i]; i++){
 5e8:	83 c3 01             	add    $0x1,%ebx
 5eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ee:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 5f2:	84 c0                	test   %al,%al
 5f4:	0f 84 23 01 00 00    	je     71d <printf+0x165>
    c = fmt[i] & 0xff;
 5fa:	0f be f8             	movsbl %al,%edi
 5fd:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 600:	85 f6                	test   %esi,%esi
 602:	75 df                	jne    5e3 <printf+0x2b>
      if(c == '%'){
 604:	83 f8 25             	cmp    $0x25,%eax
 607:	75 ce                	jne    5d7 <printf+0x1f>
        state = '%';
 609:	89 c6                	mov    %eax,%esi
 60b:	eb db                	jmp    5e8 <printf+0x30>
      if(c == 'd'){
 60d:	83 f8 64             	cmp    $0x64,%eax
 610:	74 49                	je     65b <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 612:	83 f8 78             	cmp    $0x78,%eax
 615:	0f 94 c1             	sete   %cl
 618:	83 f8 70             	cmp    $0x70,%eax
 61b:	0f 94 c2             	sete   %dl
 61e:	08 d1                	or     %dl,%cl
 620:	75 63                	jne    685 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 622:	83 f8 73             	cmp    $0x73,%eax
 625:	0f 84 84 00 00 00    	je     6af <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62b:	83 f8 63             	cmp    $0x63,%eax
 62e:	0f 84 b7 00 00 00    	je     6eb <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 634:	83 f8 25             	cmp    $0x25,%eax
 637:	0f 84 cc 00 00 00    	je     709 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63d:	ba 25 00 00 00       	mov    $0x25,%edx
 642:	8b 45 08             	mov    0x8(%ebp),%eax
 645:	e8 cd fe ff ff       	call   517 <putc>
        putc(fd, c);
 64a:	89 fa                	mov    %edi,%edx
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	e8 c3 fe ff ff       	call   517 <putc>
      }
      state = 0;
 654:	be 00 00 00 00       	mov    $0x0,%esi
 659:	eb 8d                	jmp    5e8 <printf+0x30>
        printint(fd, *ap, 10, 1);
 65b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 65e:	8b 17                	mov    (%edi),%edx
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	6a 01                	push   $0x1
 665:	b9 0a 00 00 00       	mov    $0xa,%ecx
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	e8 bf fe ff ff       	call   531 <printint>
        ap++;
 672:	83 c7 04             	add    $0x4,%edi
 675:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 678:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67b:	be 00 00 00 00       	mov    $0x0,%esi
 680:	e9 63 ff ff ff       	jmp    5e8 <printf+0x30>
        printint(fd, *ap, 16, 0);
 685:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 688:	8b 17                	mov    (%edi),%edx
 68a:	83 ec 0c             	sub    $0xc,%esp
 68d:	6a 00                	push   $0x0
 68f:	b9 10 00 00 00       	mov    $0x10,%ecx
 694:	8b 45 08             	mov    0x8(%ebp),%eax
 697:	e8 95 fe ff ff       	call   531 <printint>
        ap++;
 69c:	83 c7 04             	add    $0x4,%edi
 69f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6a2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6a5:	be 00 00 00 00       	mov    $0x0,%esi
 6aa:	e9 39 ff ff ff       	jmp    5e8 <printf+0x30>
        s = (char*)*ap;
 6af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b2:	8b 30                	mov    (%eax),%esi
        ap++;
 6b4:	83 c0 04             	add    $0x4,%eax
 6b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6ba:	85 f6                	test   %esi,%esi
 6bc:	75 28                	jne    6e6 <printf+0x12e>
          s = "(null)";
 6be:	be 74 09 00 00       	mov    $0x974,%esi
 6c3:	8b 7d 08             	mov    0x8(%ebp),%edi
 6c6:	eb 0d                	jmp    6d5 <printf+0x11d>
          putc(fd, *s);
 6c8:	0f be d2             	movsbl %dl,%edx
 6cb:	89 f8                	mov    %edi,%eax
 6cd:	e8 45 fe ff ff       	call   517 <putc>
          s++;
 6d2:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6d5:	0f b6 16             	movzbl (%esi),%edx
 6d8:	84 d2                	test   %dl,%dl
 6da:	75 ec                	jne    6c8 <printf+0x110>
      state = 0;
 6dc:	be 00 00 00 00       	mov    $0x0,%esi
 6e1:	e9 02 ff ff ff       	jmp    5e8 <printf+0x30>
 6e6:	8b 7d 08             	mov    0x8(%ebp),%edi
 6e9:	eb ea                	jmp    6d5 <printf+0x11d>
        putc(fd, *ap);
 6eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6ee:	0f be 17             	movsbl (%edi),%edx
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	e8 1e fe ff ff       	call   517 <putc>
        ap++;
 6f9:	83 c7 04             	add    $0x4,%edi
 6fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6ff:	be 00 00 00 00       	mov    $0x0,%esi
 704:	e9 df fe ff ff       	jmp    5e8 <printf+0x30>
        putc(fd, c);
 709:	89 fa                	mov    %edi,%edx
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	e8 04 fe ff ff       	call   517 <putc>
      state = 0;
 713:	be 00 00 00 00       	mov    $0x0,%esi
 718:	e9 cb fe ff ff       	jmp    5e8 <printf+0x30>
    }
  }
}
 71d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 720:	5b                   	pop    %ebx
 721:	5e                   	pop    %esi
 722:	5f                   	pop    %edi
 723:	5d                   	pop    %ebp
 724:	c3                   	ret    

00000725 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 725:	f3 0f 1e fb          	endbr32 
 729:	55                   	push   %ebp
 72a:	89 e5                	mov    %esp,%ebp
 72c:	57                   	push   %edi
 72d:	56                   	push   %esi
 72e:	53                   	push   %ebx
 72f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 732:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 735:	a1 ac 0c 00 00       	mov    0xcac,%eax
 73a:	eb 02                	jmp    73e <free+0x19>
 73c:	89 d0                	mov    %edx,%eax
 73e:	39 c8                	cmp    %ecx,%eax
 740:	73 04                	jae    746 <free+0x21>
 742:	39 08                	cmp    %ecx,(%eax)
 744:	77 12                	ja     758 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 746:	8b 10                	mov    (%eax),%edx
 748:	39 c2                	cmp    %eax,%edx
 74a:	77 f0                	ja     73c <free+0x17>
 74c:	39 c8                	cmp    %ecx,%eax
 74e:	72 08                	jb     758 <free+0x33>
 750:	39 ca                	cmp    %ecx,%edx
 752:	77 04                	ja     758 <free+0x33>
 754:	89 d0                	mov    %edx,%eax
 756:	eb e6                	jmp    73e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	8b 10                	mov    (%eax),%edx
 760:	39 d7                	cmp    %edx,%edi
 762:	74 19                	je     77d <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 764:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 767:	8b 50 04             	mov    0x4(%eax),%edx
 76a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76d:	39 ce                	cmp    %ecx,%esi
 76f:	74 1b                	je     78c <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 771:	89 08                	mov    %ecx,(%eax)
  freep = p;
 773:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 778:	5b                   	pop    %ebx
 779:	5e                   	pop    %esi
 77a:	5f                   	pop    %edi
 77b:	5d                   	pop    %ebp
 77c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 77d:	03 72 04             	add    0x4(%edx),%esi
 780:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 783:	8b 10                	mov    (%eax),%edx
 785:	8b 12                	mov    (%edx),%edx
 787:	89 53 f8             	mov    %edx,-0x8(%ebx)
 78a:	eb db                	jmp    767 <free+0x42>
    p->s.size += bp->s.size;
 78c:	03 53 fc             	add    -0x4(%ebx),%edx
 78f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 792:	8b 53 f8             	mov    -0x8(%ebx),%edx
 795:	89 10                	mov    %edx,(%eax)
 797:	eb da                	jmp    773 <free+0x4e>

00000799 <morecore>:

static Header*
morecore(uint nu)
{
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	53                   	push   %ebx
 79d:	83 ec 04             	sub    $0x4,%esp
 7a0:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7a2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 7a7:	77 05                	ja     7ae <morecore+0x15>
    nu = 4096;
 7a9:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7ae:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	50                   	push   %eax
 7b9:	e8 f1 fc ff ff       	call   4af <sbrk>
  if(p == (char*)-1)
 7be:	83 c4 10             	add    $0x10,%esp
 7c1:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c4:	74 1c                	je     7e2 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7c6:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7c9:	83 c0 08             	add    $0x8,%eax
 7cc:	83 ec 0c             	sub    $0xc,%esp
 7cf:	50                   	push   %eax
 7d0:	e8 50 ff ff ff       	call   725 <free>
  return freep;
 7d5:	a1 ac 0c 00 00       	mov    0xcac,%eax
 7da:	83 c4 10             	add    $0x10,%esp
}
 7dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7e0:	c9                   	leave  
 7e1:	c3                   	ret    
    return 0;
 7e2:	b8 00 00 00 00       	mov    $0x0,%eax
 7e7:	eb f4                	jmp    7dd <morecore+0x44>

000007e9 <malloc>:

void*
malloc(uint nbytes)
{
 7e9:	f3 0f 1e fb          	endbr32 
 7ed:	55                   	push   %ebp
 7ee:	89 e5                	mov    %esp,%ebp
 7f0:	53                   	push   %ebx
 7f1:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	8d 58 07             	lea    0x7(%eax),%ebx
 7fa:	c1 eb 03             	shr    $0x3,%ebx
 7fd:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 800:	8b 0d ac 0c 00 00    	mov    0xcac,%ecx
 806:	85 c9                	test   %ecx,%ecx
 808:	74 04                	je     80e <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	8b 01                	mov    (%ecx),%eax
 80c:	eb 4b                	jmp    859 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 80e:	c7 05 ac 0c 00 00 b0 	movl   $0xcb0,0xcac
 815:	0c 00 00 
 818:	c7 05 b0 0c 00 00 b0 	movl   $0xcb0,0xcb0
 81f:	0c 00 00 
    base.s.size = 0;
 822:	c7 05 b4 0c 00 00 00 	movl   $0x0,0xcb4
 829:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 82c:	b9 b0 0c 00 00       	mov    $0xcb0,%ecx
 831:	eb d7                	jmp    80a <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 833:	74 1a                	je     84f <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 835:	29 da                	sub    %ebx,%edx
 837:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 83d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 840:	89 0d ac 0c 00 00    	mov    %ecx,0xcac
      return (void*)(p + 1);
 846:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 849:	83 c4 04             	add    $0x4,%esp
 84c:	5b                   	pop    %ebx
 84d:	5d                   	pop    %ebp
 84e:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 84f:	8b 10                	mov    (%eax),%edx
 851:	89 11                	mov    %edx,(%ecx)
 853:	eb eb                	jmp    840 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 855:	89 c1                	mov    %eax,%ecx
 857:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 859:	8b 50 04             	mov    0x4(%eax),%edx
 85c:	39 da                	cmp    %ebx,%edx
 85e:	73 d3                	jae    833 <malloc+0x4a>
    if(p == freep)
 860:	39 05 ac 0c 00 00    	cmp    %eax,0xcac
 866:	75 ed                	jne    855 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 868:	89 d8                	mov    %ebx,%eax
 86a:	e8 2a ff ff ff       	call   799 <morecore>
 86f:	85 c0                	test   %eax,%eax
 871:	75 e2                	jne    855 <malloc+0x6c>
 873:	eb d4                	jmp    849 <malloc+0x60>
