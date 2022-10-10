
_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 39                	mov    (%ecx),%edi
  1a:	8b 41 04             	mov    0x4(%ecx),%eax
  1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  20:	83 ff 01             	cmp    $0x1,%edi
  23:	7e 25                	jle    4a <main+0x4a>
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  25:	bb 01 00 00 00       	mov    $0x1,%ebx
  2a:	39 fb                	cmp    %edi,%ebx
  2c:	7d 44                	jge    72 <main+0x72>
    if(mkdir(argv[i]) < 0){
  2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  31:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  34:	83 ec 0c             	sub    $0xc,%esp
  37:	ff 36                	pushl  (%esi)
  39:	e8 37 03 00 00       	call   375 <mkdir>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	78 19                	js     5e <main+0x5e>
  for(i = 1; i < argc; i++){
  45:	83 c3 01             	add    $0x1,%ebx
  48:	eb e0                	jmp    2a <main+0x2a>
    printf(2, "Usage: mkdir files...\n");
  4a:	83 ec 08             	sub    $0x8,%esp
  4d:	68 5c 07 00 00       	push   $0x75c
  52:	6a 02                	push   $0x2
  54:	e8 45 04 00 00       	call   49e <printf>
    exit();
  59:	e8 af 02 00 00       	call   30d <exit>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5e:	83 ec 04             	sub    $0x4,%esp
  61:	ff 36                	pushl  (%esi)
  63:	68 73 07 00 00       	push   $0x773
  68:	6a 02                	push   $0x2
  6a:	e8 2f 04 00 00       	call   49e <printf>
      break;
  6f:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  72:	e8 96 02 00 00       	call   30d <exit>

00000077 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  77:	f3 0f 1e fb          	endbr32 
  7b:	55                   	push   %ebp
  7c:	89 e5                	mov    %esp,%ebp
  7e:	56                   	push   %esi
  7f:	53                   	push   %ebx
  80:	8b 75 08             	mov    0x8(%ebp),%esi
  83:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  86:	89 f0                	mov    %esi,%eax
  88:	89 d1                	mov    %edx,%ecx
  8a:	83 c2 01             	add    $0x1,%edx
  8d:	89 c3                	mov    %eax,%ebx
  8f:	83 c0 01             	add    $0x1,%eax
  92:	0f b6 09             	movzbl (%ecx),%ecx
  95:	88 0b                	mov    %cl,(%ebx)
  97:	84 c9                	test   %cl,%cl
  99:	75 ed                	jne    88 <strcpy+0x11>
    ;
  return os;
}
  9b:	89 f0                	mov    %esi,%eax
  9d:	5b                   	pop    %ebx
  9e:	5e                   	pop    %esi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a1:	f3 0f 1e fb          	endbr32 
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 0c                	je     c1 <strcmp+0x20>
  b5:	3a 02                	cmp    (%edx),%al
  b7:	75 08                	jne    c1 <strcmp+0x20>
    p++, q++;
  b9:	83 c1 01             	add    $0x1,%ecx
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	eb ed                	jmp    ae <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  c1:	0f b6 c0             	movzbl %al,%eax
  c4:	0f b6 12             	movzbl (%edx),%edx
  c7:	29 d0                	sub    %edx,%eax
}
  c9:	5d                   	pop    %ebp
  ca:	c3                   	ret    

000000cb <strlen>:

uint
strlen(char *s)
{
  cb:	f3 0f 1e fb          	endbr32 
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d5:	b8 00 00 00 00       	mov    $0x0,%eax
  da:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  de:	74 05                	je     e5 <strlen+0x1a>
  e0:	83 c0 01             	add    $0x1,%eax
  e3:	eb f5                	jmp    da <strlen+0xf>
    ;
  return n;
}
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    

000000e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e7:	f3 0f 1e fb          	endbr32 
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	57                   	push   %edi
  ef:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f2:	89 d7                	mov    %edx,%edi
  f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	fc                   	cld    
  fb:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fd:	89 d0                	mov    %edx,%eax
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	f3 0f 1e fb          	endbr32 
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 110:	0f b6 10             	movzbl (%eax),%edx
 113:	84 d2                	test   %dl,%dl
 115:	74 09                	je     120 <strchr+0x1e>
    if(*s == c)
 117:	38 ca                	cmp    %cl,%dl
 119:	74 0a                	je     125 <strchr+0x23>
  for(; *s; s++)
 11b:	83 c0 01             	add    $0x1,%eax
 11e:	eb f0                	jmp    110 <strchr+0xe>
      return (char*)s;
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
}
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	f3 0f 1e fb          	endbr32 
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	56                   	push   %esi
 130:	53                   	push   %ebx
 131:	83 ec 1c             	sub    $0x1c,%esp
 134:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	bb 00 00 00 00       	mov    $0x0,%ebx
 13c:	89 de                	mov    %ebx,%esi
 13e:	83 c3 01             	add    $0x1,%ebx
 141:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 144:	7d 2e                	jge    174 <gets+0x4d>
    cc = read(0, &c, 1);
 146:	83 ec 04             	sub    $0x4,%esp
 149:	6a 01                	push   $0x1
 14b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 14e:	50                   	push   %eax
 14f:	6a 00                	push   $0x0
 151:	e8 cf 01 00 00       	call   325 <read>
    if(cc < 1)
 156:	83 c4 10             	add    $0x10,%esp
 159:	85 c0                	test   %eax,%eax
 15b:	7e 17                	jle    174 <gets+0x4d>
      break;
    buf[i++] = c;
 15d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 161:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 164:	3c 0a                	cmp    $0xa,%al
 166:	0f 94 c2             	sete   %dl
 169:	3c 0d                	cmp    $0xd,%al
 16b:	0f 94 c0             	sete   %al
 16e:	08 c2                	or     %al,%dl
 170:	74 ca                	je     13c <gets+0x15>
    buf[i++] = c;
 172:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 174:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 178:	89 f8                	mov    %edi,%eax
 17a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 17d:	5b                   	pop    %ebx
 17e:	5e                   	pop    %esi
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    

00000182 <stat>:

int
stat(char *n, struct stat *st)
{
 182:	f3 0f 1e fb          	endbr32 
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	56                   	push   %esi
 18a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	6a 00                	push   $0x0
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 b5 01 00 00       	call   34d <open>
  if(fd < 0)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	78 24                	js     1c3 <stat+0x41>
 19f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a1:	83 ec 08             	sub    $0x8,%esp
 1a4:	ff 75 0c             	pushl  0xc(%ebp)
 1a7:	50                   	push   %eax
 1a8:	e8 b8 01 00 00       	call   365 <fstat>
 1ad:	89 c6                	mov    %eax,%esi
  close(fd);
 1af:	89 1c 24             	mov    %ebx,(%esp)
 1b2:	e8 7e 01 00 00       	call   335 <close>
  return r;
 1b7:	83 c4 10             	add    $0x10,%esp
}
 1ba:	89 f0                	mov    %esi,%eax
 1bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bf:	5b                   	pop    %ebx
 1c0:	5e                   	pop    %esi
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
    return -1;
 1c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c8:	eb f0                	jmp    1ba <stat+0x38>

000001ca <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1ca:	f3 0f 1e fb          	endbr32 
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	57                   	push   %edi
 1d2:	56                   	push   %esi
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1d7:	0f b6 02             	movzbl (%edx),%eax
 1da:	3c 20                	cmp    $0x20,%al
 1dc:	75 05                	jne    1e3 <atoi+0x19>
 1de:	83 c2 01             	add    $0x1,%edx
 1e1:	eb f4                	jmp    1d7 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1e3:	3c 2d                	cmp    $0x2d,%al
 1e5:	74 1d                	je     204 <atoi+0x3a>
 1e7:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1ec:	3c 2b                	cmp    $0x2b,%al
 1ee:	0f 94 c1             	sete   %cl
 1f1:	3c 2d                	cmp    $0x2d,%al
 1f3:	0f 94 c0             	sete   %al
 1f6:	08 c1                	or     %al,%cl
 1f8:	74 03                	je     1fd <atoi+0x33>
    s++;
 1fa:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1fd:	b8 00 00 00 00       	mov    $0x0,%eax
 202:	eb 17                	jmp    21b <atoi+0x51>
 204:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 209:	eb e1                	jmp    1ec <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 20b:	8d 34 80             	lea    (%eax,%eax,4),%esi
 20e:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 211:	83 c2 01             	add    $0x1,%edx
 214:	0f be c9             	movsbl %cl,%ecx
 217:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 21b:	0f b6 0a             	movzbl (%edx),%ecx
 21e:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 221:	80 fb 09             	cmp    $0x9,%bl
 224:	76 e5                	jbe    20b <atoi+0x41>
  return sign*n;
 226:	0f af c7             	imul   %edi,%eax
}
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5f                   	pop    %edi
 22c:	5d                   	pop    %ebp
 22d:	c3                   	ret    

0000022e <atoo>:

int
atoo(const char *s)
{
 22e:	f3 0f 1e fb          	endbr32 
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	57                   	push   %edi
 236:	56                   	push   %esi
 237:	53                   	push   %ebx
 238:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 23b:	0f b6 0a             	movzbl (%edx),%ecx
 23e:	80 f9 20             	cmp    $0x20,%cl
 241:	75 05                	jne    248 <atoo+0x1a>
 243:	83 c2 01             	add    $0x1,%edx
 246:	eb f3                	jmp    23b <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 248:	80 f9 2d             	cmp    $0x2d,%cl
 24b:	74 23                	je     270 <atoo+0x42>
 24d:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 252:	80 f9 2b             	cmp    $0x2b,%cl
 255:	0f 94 c0             	sete   %al
 258:	89 c6                	mov    %eax,%esi
 25a:	80 f9 2d             	cmp    $0x2d,%cl
 25d:	0f 94 c0             	sete   %al
 260:	89 f3                	mov    %esi,%ebx
 262:	08 c3                	or     %al,%bl
 264:	74 03                	je     269 <atoo+0x3b>
    s++;
 266:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 269:	b8 00 00 00 00       	mov    $0x0,%eax
 26e:	eb 11                	jmp    281 <atoo+0x53>
 270:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 275:	eb db                	jmp    252 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 277:	83 c2 01             	add    $0x1,%edx
 27a:	0f be c9             	movsbl %cl,%ecx
 27d:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 281:	0f b6 0a             	movzbl (%edx),%ecx
 284:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 287:	80 fb 07             	cmp    $0x7,%bl
 28a:	76 eb                	jbe    277 <atoo+0x49>
  return sign*n;
 28c:	0f af c7             	imul   %edi,%eax
}
 28f:	5b                   	pop    %ebx
 290:	5e                   	pop    %esi
 291:	5f                   	pop    %edi
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    

00000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 294:	f3 0f 1e fb          	endbr32 
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	53                   	push   %ebx
 29c:	8b 55 08             	mov    0x8(%ebp),%edx
 29f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2a5:	eb 09                	jmp    2b0 <strncmp+0x1c>
      n--, p++, q++;
 2a7:	83 e8 01             	sub    $0x1,%eax
 2aa:	83 c2 01             	add    $0x1,%edx
 2ad:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2b0:	85 c0                	test   %eax,%eax
 2b2:	74 0b                	je     2bf <strncmp+0x2b>
 2b4:	0f b6 1a             	movzbl (%edx),%ebx
 2b7:	84 db                	test   %bl,%bl
 2b9:	74 04                	je     2bf <strncmp+0x2b>
 2bb:	3a 19                	cmp    (%ecx),%bl
 2bd:	74 e8                	je     2a7 <strncmp+0x13>
    if(n == 0)
 2bf:	85 c0                	test   %eax,%eax
 2c1:	74 0b                	je     2ce <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2c3:	0f b6 02             	movzbl (%edx),%eax
 2c6:	0f b6 11             	movzbl (%ecx),%edx
 2c9:	29 d0                	sub    %edx,%eax
}
 2cb:	5b                   	pop    %ebx
 2cc:	5d                   	pop    %ebp
 2cd:	c3                   	ret    
      return 0;
 2ce:	b8 00 00 00 00       	mov    $0x0,%eax
 2d3:	eb f6                	jmp    2cb <strncmp+0x37>

000002d5 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d5:	f3 0f 1e fb          	endbr32 
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	56                   	push   %esi
 2dd:	53                   	push   %ebx
 2de:	8b 75 08             	mov    0x8(%ebp),%esi
 2e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2e4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2e7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2e9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2ec:	85 c0                	test   %eax,%eax
 2ee:	7e 0f                	jle    2ff <memmove+0x2a>
    *dst++ = *src++;
 2f0:	0f b6 01             	movzbl (%ecx),%eax
 2f3:	88 02                	mov    %al,(%edx)
 2f5:	8d 49 01             	lea    0x1(%ecx),%ecx
 2f8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2fb:	89 d8                	mov    %ebx,%eax
 2fd:	eb ea                	jmp    2e9 <memmove+0x14>
  return vdst;
}
 2ff:	89 f0                	mov    %esi,%eax
 301:	5b                   	pop    %ebx
 302:	5e                   	pop    %esi
 303:	5d                   	pop    %ebp
 304:	c3                   	ret    

00000305 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 305:	b8 01 00 00 00       	mov    $0x1,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <exit>:
SYSCALL(exit)
 30d:	b8 02 00 00 00       	mov    $0x2,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <wait>:
SYSCALL(wait)
 315:	b8 03 00 00 00       	mov    $0x3,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <pipe>:
SYSCALL(pipe)
 31d:	b8 04 00 00 00       	mov    $0x4,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <read>:
SYSCALL(read)
 325:	b8 05 00 00 00       	mov    $0x5,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <write>:
SYSCALL(write)
 32d:	b8 10 00 00 00       	mov    $0x10,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <close>:
SYSCALL(close)
 335:	b8 15 00 00 00       	mov    $0x15,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <kill>:
SYSCALL(kill)
 33d:	b8 06 00 00 00       	mov    $0x6,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <exec>:
SYSCALL(exec)
 345:	b8 07 00 00 00       	mov    $0x7,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <open>:
SYSCALL(open)
 34d:	b8 0f 00 00 00       	mov    $0xf,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <mknod>:
SYSCALL(mknod)
 355:	b8 11 00 00 00       	mov    $0x11,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <unlink>:
SYSCALL(unlink)
 35d:	b8 12 00 00 00       	mov    $0x12,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <fstat>:
SYSCALL(fstat)
 365:	b8 08 00 00 00       	mov    $0x8,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <link>:
SYSCALL(link)
 36d:	b8 13 00 00 00       	mov    $0x13,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <mkdir>:
SYSCALL(mkdir)
 375:	b8 14 00 00 00       	mov    $0x14,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <chdir>:
SYSCALL(chdir)
 37d:	b8 09 00 00 00       	mov    $0x9,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <dup>:
SYSCALL(dup)
 385:	b8 0a 00 00 00       	mov    $0xa,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <getpid>:
SYSCALL(getpid)
 38d:	b8 0b 00 00 00       	mov    $0xb,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <sbrk>:
SYSCALL(sbrk)
 395:	b8 0c 00 00 00       	mov    $0xc,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <sleep>:
SYSCALL(sleep)
 39d:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <uptime>:
SYSCALL(uptime)
 3a5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <halt>:
SYSCALL(halt)
 3ad:	b8 16 00 00 00       	mov    $0x16,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <date>:
SYSCALL(date)
 3b5:	b8 17 00 00 00       	mov    $0x17,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <getuid>:
SYSCALL(getuid)
 3bd:	b8 18 00 00 00       	mov    $0x18,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <getgid>:
SYSCALL(getgid)
 3c5:	b8 19 00 00 00       	mov    $0x19,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getppid>:
SYSCALL(getppid)
 3cd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <setuid>:
SYSCALL(setuid)
 3d5:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <setgid>:
SYSCALL(setgid)
 3dd:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <getprocs>:
SYSCALL(getprocs)
 3e5:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <setpriority>:
SYSCALL(setpriority)
 3ed:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <getpriority>:
SYSCALL(getpriority)
 3f5:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 1c             	sub    $0x1c,%esp
 403:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 406:	6a 01                	push   $0x1
 408:	8d 55 f4             	lea    -0xc(%ebp),%edx
 40b:	52                   	push   %edx
 40c:	50                   	push   %eax
 40d:	e8 1b ff ff ff       	call   32d <write>
}
 412:	83 c4 10             	add    $0x10,%esp
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	57                   	push   %edi
 41b:	56                   	push   %esi
 41c:	53                   	push   %ebx
 41d:	83 ec 2c             	sub    $0x2c,%esp
 420:	89 45 d0             	mov    %eax,-0x30(%ebp)
 423:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 429:	0f 95 c2             	setne  %dl
 42c:	89 f0                	mov    %esi,%eax
 42e:	c1 e8 1f             	shr    $0x1f,%eax
 431:	84 c2                	test   %al,%dl
 433:	74 42                	je     477 <printint+0x60>
    neg = 1;
    x = -xx;
 435:	f7 de                	neg    %esi
    neg = 1;
 437:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 43e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 443:	89 f0                	mov    %esi,%eax
 445:	ba 00 00 00 00       	mov    $0x0,%edx
 44a:	f7 f1                	div    %ecx
 44c:	89 df                	mov    %ebx,%edi
 44e:	83 c3 01             	add    $0x1,%ebx
 451:	0f b6 92 98 07 00 00 	movzbl 0x798(%edx),%edx
 458:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 45c:	89 f2                	mov    %esi,%edx
 45e:	89 c6                	mov    %eax,%esi
 460:	39 d1                	cmp    %edx,%ecx
 462:	76 df                	jbe    443 <printint+0x2c>
  if(neg)
 464:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 468:	74 2f                	je     499 <printint+0x82>
    buf[i++] = '-';
 46a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 46f:	8d 5f 02             	lea    0x2(%edi),%ebx
 472:	8b 75 d0             	mov    -0x30(%ebp),%esi
 475:	eb 15                	jmp    48c <printint+0x75>
  neg = 0;
 477:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 47e:	eb be                	jmp    43e <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 480:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 485:	89 f0                	mov    %esi,%eax
 487:	e8 71 ff ff ff       	call   3fd <putc>
  while(--i >= 0)
 48c:	83 eb 01             	sub    $0x1,%ebx
 48f:	79 ef                	jns    480 <printint+0x69>
}
 491:	83 c4 2c             	add    $0x2c,%esp
 494:	5b                   	pop    %ebx
 495:	5e                   	pop    %esi
 496:	5f                   	pop    %edi
 497:	5d                   	pop    %ebp
 498:	c3                   	ret    
 499:	8b 75 d0             	mov    -0x30(%ebp),%esi
 49c:	eb ee                	jmp    48c <printint+0x75>

0000049e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49e:	f3 0f 1e fb          	endbr32 
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	57                   	push   %edi
 4a6:	56                   	push   %esi
 4a7:	53                   	push   %ebx
 4a8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ab:	8d 45 10             	lea    0x10(%ebp),%eax
 4ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4b1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4b6:	bb 00 00 00 00       	mov    $0x0,%ebx
 4bb:	eb 14                	jmp    4d1 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4bd:	89 fa                	mov    %edi,%edx
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	e8 36 ff ff ff       	call   3fd <putc>
 4c7:	eb 05                	jmp    4ce <printf+0x30>
      }
    } else if(state == '%'){
 4c9:	83 fe 25             	cmp    $0x25,%esi
 4cc:	74 25                	je     4f3 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4ce:	83 c3 01             	add    $0x1,%ebx
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4d8:	84 c0                	test   %al,%al
 4da:	0f 84 23 01 00 00    	je     603 <printf+0x165>
    c = fmt[i] & 0xff;
 4e0:	0f be f8             	movsbl %al,%edi
 4e3:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4e6:	85 f6                	test   %esi,%esi
 4e8:	75 df                	jne    4c9 <printf+0x2b>
      if(c == '%'){
 4ea:	83 f8 25             	cmp    $0x25,%eax
 4ed:	75 ce                	jne    4bd <printf+0x1f>
        state = '%';
 4ef:	89 c6                	mov    %eax,%esi
 4f1:	eb db                	jmp    4ce <printf+0x30>
      if(c == 'd'){
 4f3:	83 f8 64             	cmp    $0x64,%eax
 4f6:	74 49                	je     541 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4f8:	83 f8 78             	cmp    $0x78,%eax
 4fb:	0f 94 c1             	sete   %cl
 4fe:	83 f8 70             	cmp    $0x70,%eax
 501:	0f 94 c2             	sete   %dl
 504:	08 d1                	or     %dl,%cl
 506:	75 63                	jne    56b <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 508:	83 f8 73             	cmp    $0x73,%eax
 50b:	0f 84 84 00 00 00    	je     595 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 511:	83 f8 63             	cmp    $0x63,%eax
 514:	0f 84 b7 00 00 00    	je     5d1 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 51a:	83 f8 25             	cmp    $0x25,%eax
 51d:	0f 84 cc 00 00 00    	je     5ef <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 523:	ba 25 00 00 00       	mov    $0x25,%edx
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	e8 cd fe ff ff       	call   3fd <putc>
        putc(fd, c);
 530:	89 fa                	mov    %edi,%edx
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	e8 c3 fe ff ff       	call   3fd <putc>
      }
      state = 0;
 53a:	be 00 00 00 00       	mov    $0x0,%esi
 53f:	eb 8d                	jmp    4ce <printf+0x30>
        printint(fd, *ap, 10, 1);
 541:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 544:	8b 17                	mov    (%edi),%edx
 546:	83 ec 0c             	sub    $0xc,%esp
 549:	6a 01                	push   $0x1
 54b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	e8 bf fe ff ff       	call   417 <printint>
        ap++;
 558:	83 c7 04             	add    $0x4,%edi
 55b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 55e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 561:	be 00 00 00 00       	mov    $0x0,%esi
 566:	e9 63 ff ff ff       	jmp    4ce <printf+0x30>
        printint(fd, *ap, 16, 0);
 56b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 56e:	8b 17                	mov    (%edi),%edx
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	6a 00                	push   $0x0
 575:	b9 10 00 00 00       	mov    $0x10,%ecx
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	e8 95 fe ff ff       	call   417 <printint>
        ap++;
 582:	83 c7 04             	add    $0x4,%edi
 585:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 588:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58b:	be 00 00 00 00       	mov    $0x0,%esi
 590:	e9 39 ff ff ff       	jmp    4ce <printf+0x30>
        s = (char*)*ap;
 595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 598:	8b 30                	mov    (%eax),%esi
        ap++;
 59a:	83 c0 04             	add    $0x4,%eax
 59d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5a0:	85 f6                	test   %esi,%esi
 5a2:	75 28                	jne    5cc <printf+0x12e>
          s = "(null)";
 5a4:	be 8f 07 00 00       	mov    $0x78f,%esi
 5a9:	8b 7d 08             	mov    0x8(%ebp),%edi
 5ac:	eb 0d                	jmp    5bb <printf+0x11d>
          putc(fd, *s);
 5ae:	0f be d2             	movsbl %dl,%edx
 5b1:	89 f8                	mov    %edi,%eax
 5b3:	e8 45 fe ff ff       	call   3fd <putc>
          s++;
 5b8:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5bb:	0f b6 16             	movzbl (%esi),%edx
 5be:	84 d2                	test   %dl,%dl
 5c0:	75 ec                	jne    5ae <printf+0x110>
      state = 0;
 5c2:	be 00 00 00 00       	mov    $0x0,%esi
 5c7:	e9 02 ff ff ff       	jmp    4ce <printf+0x30>
 5cc:	8b 7d 08             	mov    0x8(%ebp),%edi
 5cf:	eb ea                	jmp    5bb <printf+0x11d>
        putc(fd, *ap);
 5d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5d4:	0f be 17             	movsbl (%edi),%edx
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	e8 1e fe ff ff       	call   3fd <putc>
        ap++;
 5df:	83 c7 04             	add    $0x4,%edi
 5e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e5:	be 00 00 00 00       	mov    $0x0,%esi
 5ea:	e9 df fe ff ff       	jmp    4ce <printf+0x30>
        putc(fd, c);
 5ef:	89 fa                	mov    %edi,%edx
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	e8 04 fe ff ff       	call   3fd <putc>
      state = 0;
 5f9:	be 00 00 00 00       	mov    $0x0,%esi
 5fe:	e9 cb fe ff ff       	jmp    4ce <printf+0x30>
    }
  }
}
 603:	8d 65 f4             	lea    -0xc(%ebp),%esp
 606:	5b                   	pop    %ebx
 607:	5e                   	pop    %esi
 608:	5f                   	pop    %edi
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    

0000060b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60b:	f3 0f 1e fb          	endbr32 
 60f:	55                   	push   %ebp
 610:	89 e5                	mov    %esp,%ebp
 612:	57                   	push   %edi
 613:	56                   	push   %esi
 614:	53                   	push   %ebx
 615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 618:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61b:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 620:	eb 02                	jmp    624 <free+0x19>
 622:	89 d0                	mov    %edx,%eax
 624:	39 c8                	cmp    %ecx,%eax
 626:	73 04                	jae    62c <free+0x21>
 628:	39 08                	cmp    %ecx,(%eax)
 62a:	77 12                	ja     63e <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62c:	8b 10                	mov    (%eax),%edx
 62e:	39 c2                	cmp    %eax,%edx
 630:	77 f0                	ja     622 <free+0x17>
 632:	39 c8                	cmp    %ecx,%eax
 634:	72 08                	jb     63e <free+0x33>
 636:	39 ca                	cmp    %ecx,%edx
 638:	77 04                	ja     63e <free+0x33>
 63a:	89 d0                	mov    %edx,%eax
 63c:	eb e6                	jmp    624 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 63e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 641:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 644:	8b 10                	mov    (%eax),%edx
 646:	39 d7                	cmp    %edx,%edi
 648:	74 19                	je     663 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 ce                	cmp    %ecx,%esi
 655:	74 1b                	je     672 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 657:	89 08                	mov    %ecx,(%eax)
  freep = p;
 659:	a3 a0 0a 00 00       	mov    %eax,0xaa0
}
 65e:	5b                   	pop    %ebx
 65f:	5e                   	pop    %esi
 660:	5f                   	pop    %edi
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 663:	03 72 04             	add    0x4(%edx),%esi
 666:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 12                	mov    (%edx),%edx
 66d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 670:	eb db                	jmp    64d <free+0x42>
    p->s.size += bp->s.size;
 672:	03 53 fc             	add    -0x4(%ebx),%edx
 675:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 678:	8b 53 f8             	mov    -0x8(%ebx),%edx
 67b:	89 10                	mov    %edx,(%eax)
 67d:	eb da                	jmp    659 <free+0x4e>

0000067f <morecore>:

static Header*
morecore(uint nu)
{
 67f:	55                   	push   %ebp
 680:	89 e5                	mov    %esp,%ebp
 682:	53                   	push   %ebx
 683:	83 ec 04             	sub    $0x4,%esp
 686:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 688:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 68d:	77 05                	ja     694 <morecore+0x15>
    nu = 4096;
 68f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 694:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 69b:	83 ec 0c             	sub    $0xc,%esp
 69e:	50                   	push   %eax
 69f:	e8 f1 fc ff ff       	call   395 <sbrk>
  if(p == (char*)-1)
 6a4:	83 c4 10             	add    $0x10,%esp
 6a7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6aa:	74 1c                	je     6c8 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6ac:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6af:	83 c0 08             	add    $0x8,%eax
 6b2:	83 ec 0c             	sub    $0xc,%esp
 6b5:	50                   	push   %eax
 6b6:	e8 50 ff ff ff       	call   60b <free>
  return freep;
 6bb:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 6c0:	83 c4 10             	add    $0x10,%esp
}
 6c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6c6:	c9                   	leave  
 6c7:	c3                   	ret    
    return 0;
 6c8:	b8 00 00 00 00       	mov    $0x0,%eax
 6cd:	eb f4                	jmp    6c3 <morecore+0x44>

000006cf <malloc>:

void*
malloc(uint nbytes)
{
 6cf:	f3 0f 1e fb          	endbr32 
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	53                   	push   %ebx
 6d7:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	8d 58 07             	lea    0x7(%eax),%ebx
 6e0:	c1 eb 03             	shr    $0x3,%ebx
 6e3:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6e6:	8b 0d a0 0a 00 00    	mov    0xaa0,%ecx
 6ec:	85 c9                	test   %ecx,%ecx
 6ee:	74 04                	je     6f4 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f0:	8b 01                	mov    (%ecx),%eax
 6f2:	eb 4b                	jmp    73f <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6f4:	c7 05 a0 0a 00 00 a4 	movl   $0xaa4,0xaa0
 6fb:	0a 00 00 
 6fe:	c7 05 a4 0a 00 00 a4 	movl   $0xaa4,0xaa4
 705:	0a 00 00 
    base.s.size = 0;
 708:	c7 05 a8 0a 00 00 00 	movl   $0x0,0xaa8
 70f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 712:	b9 a4 0a 00 00       	mov    $0xaa4,%ecx
 717:	eb d7                	jmp    6f0 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 719:	74 1a                	je     735 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 71b:	29 da                	sub    %ebx,%edx
 71d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 720:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 723:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 726:	89 0d a0 0a 00 00    	mov    %ecx,0xaa0
      return (void*)(p + 1);
 72c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 72f:	83 c4 04             	add    $0x4,%esp
 732:	5b                   	pop    %ebx
 733:	5d                   	pop    %ebp
 734:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 735:	8b 10                	mov    (%eax),%edx
 737:	89 11                	mov    %edx,(%ecx)
 739:	eb eb                	jmp    726 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73b:	89 c1                	mov    %eax,%ecx
 73d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 73f:	8b 50 04             	mov    0x4(%eax),%edx
 742:	39 da                	cmp    %ebx,%edx
 744:	73 d3                	jae    719 <malloc+0x4a>
    if(p == freep)
 746:	39 05 a0 0a 00 00    	cmp    %eax,0xaa0
 74c:	75 ed                	jne    73b <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 74e:	89 d8                	mov    %ebx,%eax
 750:	e8 2a ff ff ff       	call   67f <morecore>
 755:	85 c0                	test   %eax,%eax
 757:	75 e2                	jne    73b <malloc+0x6c>
 759:	eb d4                	jmp    72f <malloc+0x60>
