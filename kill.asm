
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "pdx.h"
#endif // PDX_XV6

int
main(int argc, char **argv)
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
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1d:	83 fe 01             	cmp    $0x1,%esi
  20:	7e 07                	jle    29 <main+0x29>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  22:	bb 01 00 00 00       	mov    $0x1,%ebx
  27:	eb 2d                	jmp    56 <main+0x56>
    printf(2, "usage: kill pid...\n");
  29:	83 ec 08             	sub    $0x8,%esp
  2c:	68 44 07 00 00       	push   $0x744
  31:	6a 02                	push   $0x2
  33:	e8 4e 04 00 00       	call   486 <printf>
    exit();
  38:	e8 b8 02 00 00       	call   2f5 <exit>
    kill(atoi(argv[i]));
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 34 9f             	pushl  (%edi,%ebx,4)
  43:	e8 6a 01 00 00       	call   1b2 <atoi>
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 d5 02 00 00       	call   325 <kill>
  for(i=1; i<argc; i++)
  50:	83 c3 01             	add    $0x1,%ebx
  53:	83 c4 10             	add    $0x10,%esp
  56:	39 f3                	cmp    %esi,%ebx
  58:	7c e3                	jl     3d <main+0x3d>
  exit();
  5a:	e8 96 02 00 00       	call   2f5 <exit>

0000005f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5f:	f3 0f 1e fb          	endbr32 
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	56                   	push   %esi
  67:	53                   	push   %ebx
  68:	8b 75 08             	mov    0x8(%ebp),%esi
  6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	89 f0                	mov    %esi,%eax
  70:	89 d1                	mov    %edx,%ecx
  72:	83 c2 01             	add    $0x1,%edx
  75:	89 c3                	mov    %eax,%ebx
  77:	83 c0 01             	add    $0x1,%eax
  7a:	0f b6 09             	movzbl (%ecx),%ecx
  7d:	88 0b                	mov    %cl,(%ebx)
  7f:	84 c9                	test   %cl,%cl
  81:	75 ed                	jne    70 <strcpy+0x11>
    ;
  return os;
}
  83:	89 f0                	mov    %esi,%eax
  85:	5b                   	pop    %ebx
  86:	5e                   	pop    %esi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	f3 0f 1e fb          	endbr32 
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  96:	0f b6 01             	movzbl (%ecx),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 0c                	je     a9 <strcmp+0x20>
  9d:	3a 02                	cmp    (%edx),%al
  9f:	75 08                	jne    a9 <strcmp+0x20>
    p++, q++;
  a1:	83 c1 01             	add    $0x1,%ecx
  a4:	83 c2 01             	add    $0x1,%edx
  a7:	eb ed                	jmp    96 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  a9:	0f b6 c0             	movzbl %al,%eax
  ac:	0f b6 12             	movzbl (%edx),%edx
  af:	29 d0                	sub    %edx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

uint
strlen(char *s)
{
  b3:	f3 0f 1e fb          	endbr32 
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c6:	74 05                	je     cd <strlen+0x1a>
  c8:	83 c0 01             	add    $0x1,%eax
  cb:	eb f5                	jmp    c2 <strlen+0xf>
    ;
  return n;
}
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <memset>:

void*
memset(void *dst, int c, uint n)
{
  cf:	f3 0f 1e fb          	endbr32 
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	57                   	push   %edi
  d7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  da:	89 d7                	mov    %edx,%edi
  dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	fc                   	cld    
  e3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e5:	89 d0                	mov    %edx,%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	84 d2                	test   %dl,%dl
  fd:	74 09                	je     108 <strchr+0x1e>
    if(*s == c)
  ff:	38 ca                	cmp    %cl,%dl
 101:	74 0a                	je     10d <strchr+0x23>
  for(; *s; s++)
 103:	83 c0 01             	add    $0x1,%eax
 106:	eb f0                	jmp    f8 <strchr+0xe>
      return (char*)s;
  return 0;
 108:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    

0000010f <gets>:

char*
gets(char *buf, int max)
{
 10f:	f3 0f 1e fb          	endbr32 
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	56                   	push   %esi
 118:	53                   	push   %ebx
 119:	83 ec 1c             	sub    $0x1c,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11f:	bb 00 00 00 00       	mov    $0x0,%ebx
 124:	89 de                	mov    %ebx,%esi
 126:	83 c3 01             	add    $0x1,%ebx
 129:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12c:	7d 2e                	jge    15c <gets+0x4d>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 e7             	lea    -0x19(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 cf 01 00 00       	call   30d <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x4d>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14c:	3c 0a                	cmp    $0xa,%al
 14e:	0f 94 c2             	sete   %dl
 151:	3c 0d                	cmp    $0xd,%al
 153:	0f 94 c0             	sete   %al
 156:	08 c2                	or     %al,%dl
 158:	74 ca                	je     124 <gets+0x15>
    buf[i++] = c;
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 160:	89 f8                	mov    %edi,%eax
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <stat>:

int
stat(char *n, struct stat *st)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	6a 00                	push   $0x0
 178:	ff 75 08             	pushl  0x8(%ebp)
 17b:	e8 b5 01 00 00       	call   335 <open>
  if(fd < 0)
 180:	83 c4 10             	add    $0x10,%esp
 183:	85 c0                	test   %eax,%eax
 185:	78 24                	js     1ab <stat+0x41>
 187:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	ff 75 0c             	pushl  0xc(%ebp)
 18f:	50                   	push   %eax
 190:	e8 b8 01 00 00       	call   34d <fstat>
 195:	89 c6                	mov    %eax,%esi
  close(fd);
 197:	89 1c 24             	mov    %ebx,(%esp)
 19a:	e8 7e 01 00 00       	call   31d <close>
  return r;
 19f:	83 c4 10             	add    $0x10,%esp
}
 1a2:	89 f0                	mov    %esi,%eax
 1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a7:	5b                   	pop    %ebx
 1a8:	5e                   	pop    %esi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
    return -1;
 1ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b0:	eb f0                	jmp    1a2 <stat+0x38>

000001b2 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1b2:	f3 0f 1e fb          	endbr32 
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	57                   	push   %edi
 1ba:	56                   	push   %esi
 1bb:	53                   	push   %ebx
 1bc:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1bf:	0f b6 02             	movzbl (%edx),%eax
 1c2:	3c 20                	cmp    $0x20,%al
 1c4:	75 05                	jne    1cb <atoi+0x19>
 1c6:	83 c2 01             	add    $0x1,%edx
 1c9:	eb f4                	jmp    1bf <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 1cb:	3c 2d                	cmp    $0x2d,%al
 1cd:	74 1d                	je     1ec <atoi+0x3a>
 1cf:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1d4:	3c 2b                	cmp    $0x2b,%al
 1d6:	0f 94 c1             	sete   %cl
 1d9:	3c 2d                	cmp    $0x2d,%al
 1db:	0f 94 c0             	sete   %al
 1de:	08 c1                	or     %al,%cl
 1e0:	74 03                	je     1e5 <atoi+0x33>
    s++;
 1e2:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1e5:	b8 00 00 00 00       	mov    $0x0,%eax
 1ea:	eb 17                	jmp    203 <atoi+0x51>
 1ec:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1f1:	eb e1                	jmp    1d4 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1f3:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1f6:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1f9:	83 c2 01             	add    $0x1,%edx
 1fc:	0f be c9             	movsbl %cl,%ecx
 1ff:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 203:	0f b6 0a             	movzbl (%edx),%ecx
 206:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 209:	80 fb 09             	cmp    $0x9,%bl
 20c:	76 e5                	jbe    1f3 <atoi+0x41>
  return sign*n;
 20e:	0f af c7             	imul   %edi,%eax
}
 211:	5b                   	pop    %ebx
 212:	5e                   	pop    %esi
 213:	5f                   	pop    %edi
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    

00000216 <atoo>:

int
atoo(const char *s)
{
 216:	f3 0f 1e fb          	endbr32 
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	57                   	push   %edi
 21e:	56                   	push   %esi
 21f:	53                   	push   %ebx
 220:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 223:	0f b6 0a             	movzbl (%edx),%ecx
 226:	80 f9 20             	cmp    $0x20,%cl
 229:	75 05                	jne    230 <atoo+0x1a>
 22b:	83 c2 01             	add    $0x1,%edx
 22e:	eb f3                	jmp    223 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 230:	80 f9 2d             	cmp    $0x2d,%cl
 233:	74 23                	je     258 <atoo+0x42>
 235:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 23a:	80 f9 2b             	cmp    $0x2b,%cl
 23d:	0f 94 c0             	sete   %al
 240:	89 c6                	mov    %eax,%esi
 242:	80 f9 2d             	cmp    $0x2d,%cl
 245:	0f 94 c0             	sete   %al
 248:	89 f3                	mov    %esi,%ebx
 24a:	08 c3                	or     %al,%bl
 24c:	74 03                	je     251 <atoo+0x3b>
    s++;
 24e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 251:	b8 00 00 00 00       	mov    $0x0,%eax
 256:	eb 11                	jmp    269 <atoo+0x53>
 258:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 25d:	eb db                	jmp    23a <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 25f:	83 c2 01             	add    $0x1,%edx
 262:	0f be c9             	movsbl %cl,%ecx
 265:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 269:	0f b6 0a             	movzbl (%edx),%ecx
 26c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 26f:	80 fb 07             	cmp    $0x7,%bl
 272:	76 eb                	jbe    25f <atoo+0x49>
  return sign*n;
 274:	0f af c7             	imul   %edi,%eax
}
 277:	5b                   	pop    %ebx
 278:	5e                   	pop    %esi
 279:	5f                   	pop    %edi
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    

0000027c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 27c:	f3 0f 1e fb          	endbr32 
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
 287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 28a:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 28d:	eb 09                	jmp    298 <strncmp+0x1c>
      n--, p++, q++;
 28f:	83 e8 01             	sub    $0x1,%eax
 292:	83 c2 01             	add    $0x1,%edx
 295:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 298:	85 c0                	test   %eax,%eax
 29a:	74 0b                	je     2a7 <strncmp+0x2b>
 29c:	0f b6 1a             	movzbl (%edx),%ebx
 29f:	84 db                	test   %bl,%bl
 2a1:	74 04                	je     2a7 <strncmp+0x2b>
 2a3:	3a 19                	cmp    (%ecx),%bl
 2a5:	74 e8                	je     28f <strncmp+0x13>
    if(n == 0)
 2a7:	85 c0                	test   %eax,%eax
 2a9:	74 0b                	je     2b6 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2ab:	0f b6 02             	movzbl (%edx),%eax
 2ae:	0f b6 11             	movzbl (%ecx),%edx
 2b1:	29 d0                	sub    %edx,%eax
}
 2b3:	5b                   	pop    %ebx
 2b4:	5d                   	pop    %ebp
 2b5:	c3                   	ret    
      return 0;
 2b6:	b8 00 00 00 00       	mov    $0x0,%eax
 2bb:	eb f6                	jmp    2b3 <strncmp+0x37>

000002bd <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bd:	f3 0f 1e fb          	endbr32 
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	56                   	push   %esi
 2c5:	53                   	push   %ebx
 2c6:	8b 75 08             	mov    0x8(%ebp),%esi
 2c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2cc:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2cf:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2d4:	85 c0                	test   %eax,%eax
 2d6:	7e 0f                	jle    2e7 <memmove+0x2a>
    *dst++ = *src++;
 2d8:	0f b6 01             	movzbl (%ecx),%eax
 2db:	88 02                	mov    %al,(%edx)
 2dd:	8d 49 01             	lea    0x1(%ecx),%ecx
 2e0:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2e3:	89 d8                	mov    %ebx,%eax
 2e5:	eb ea                	jmp    2d1 <memmove+0x14>
  return vdst;
}
 2e7:	89 f0                	mov    %esi,%eax
 2e9:	5b                   	pop    %ebx
 2ea:	5e                   	pop    %esi
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    

000002ed <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ed:	b8 01 00 00 00       	mov    $0x1,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <exit>:
SYSCALL(exit)
 2f5:	b8 02 00 00 00       	mov    $0x2,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <wait>:
SYSCALL(wait)
 2fd:	b8 03 00 00 00       	mov    $0x3,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <pipe>:
SYSCALL(pipe)
 305:	b8 04 00 00 00       	mov    $0x4,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <read>:
SYSCALL(read)
 30d:	b8 05 00 00 00       	mov    $0x5,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <write>:
SYSCALL(write)
 315:	b8 10 00 00 00       	mov    $0x10,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <close>:
SYSCALL(close)
 31d:	b8 15 00 00 00       	mov    $0x15,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <kill>:
SYSCALL(kill)
 325:	b8 06 00 00 00       	mov    $0x6,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exec>:
SYSCALL(exec)
 32d:	b8 07 00 00 00       	mov    $0x7,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <open>:
SYSCALL(open)
 335:	b8 0f 00 00 00       	mov    $0xf,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <mknod>:
SYSCALL(mknod)
 33d:	b8 11 00 00 00       	mov    $0x11,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <unlink>:
SYSCALL(unlink)
 345:	b8 12 00 00 00       	mov    $0x12,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <fstat>:
SYSCALL(fstat)
 34d:	b8 08 00 00 00       	mov    $0x8,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <link>:
SYSCALL(link)
 355:	b8 13 00 00 00       	mov    $0x13,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mkdir>:
SYSCALL(mkdir)
 35d:	b8 14 00 00 00       	mov    $0x14,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <chdir>:
SYSCALL(chdir)
 365:	b8 09 00 00 00       	mov    $0x9,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <dup>:
SYSCALL(dup)
 36d:	b8 0a 00 00 00       	mov    $0xa,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getpid>:
SYSCALL(getpid)
 375:	b8 0b 00 00 00       	mov    $0xb,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <sbrk>:
SYSCALL(sbrk)
 37d:	b8 0c 00 00 00       	mov    $0xc,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <sleep>:
SYSCALL(sleep)
 385:	b8 0d 00 00 00       	mov    $0xd,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <uptime>:
SYSCALL(uptime)
 38d:	b8 0e 00 00 00       	mov    $0xe,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <halt>:
SYSCALL(halt)
 395:	b8 16 00 00 00       	mov    $0x16,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <date>:
SYSCALL(date)
 39d:	b8 17 00 00 00       	mov    $0x17,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <getuid>:
SYSCALL(getuid)
 3a5:	b8 18 00 00 00       	mov    $0x18,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getgid>:
SYSCALL(getgid)
 3ad:	b8 19 00 00 00       	mov    $0x19,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <getppid>:
SYSCALL(getppid)
 3b5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <setuid>:
SYSCALL(setuid)
 3bd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <setgid>:
SYSCALL(setgid)
 3c5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getprocs>:
SYSCALL(getprocs)
 3cd:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <setpriority>:
SYSCALL(setpriority)
 3d5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <getpriority>:
SYSCALL(getpriority)
 3dd:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e5:	55                   	push   %ebp
 3e6:	89 e5                	mov    %esp,%ebp
 3e8:	83 ec 1c             	sub    $0x1c,%esp
 3eb:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3ee:	6a 01                	push   $0x1
 3f0:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3f3:	52                   	push   %edx
 3f4:	50                   	push   %eax
 3f5:	e8 1b ff ff ff       	call   315 <write>
}
 3fa:	83 c4 10             	add    $0x10,%esp
 3fd:	c9                   	leave  
 3fe:	c3                   	ret    

000003ff <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	57                   	push   %edi
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	83 ec 2c             	sub    $0x2c,%esp
 408:	89 45 d0             	mov    %eax,-0x30(%ebp)
 40b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 411:	0f 95 c2             	setne  %dl
 414:	89 f0                	mov    %esi,%eax
 416:	c1 e8 1f             	shr    $0x1f,%eax
 419:	84 c2                	test   %al,%dl
 41b:	74 42                	je     45f <printint+0x60>
    neg = 1;
    x = -xx;
 41d:	f7 de                	neg    %esi
    neg = 1;
 41f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 426:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 42b:	89 f0                	mov    %esi,%eax
 42d:	ba 00 00 00 00       	mov    $0x0,%edx
 432:	f7 f1                	div    %ecx
 434:	89 df                	mov    %ebx,%edi
 436:	83 c3 01             	add    $0x1,%ebx
 439:	0f b6 92 60 07 00 00 	movzbl 0x760(%edx),%edx
 440:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 444:	89 f2                	mov    %esi,%edx
 446:	89 c6                	mov    %eax,%esi
 448:	39 d1                	cmp    %edx,%ecx
 44a:	76 df                	jbe    42b <printint+0x2c>
  if(neg)
 44c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 450:	74 2f                	je     481 <printint+0x82>
    buf[i++] = '-';
 452:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 457:	8d 5f 02             	lea    0x2(%edi),%ebx
 45a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 45d:	eb 15                	jmp    474 <printint+0x75>
  neg = 0;
 45f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 466:	eb be                	jmp    426 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 468:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 46d:	89 f0                	mov    %esi,%eax
 46f:	e8 71 ff ff ff       	call   3e5 <putc>
  while(--i >= 0)
 474:	83 eb 01             	sub    $0x1,%ebx
 477:	79 ef                	jns    468 <printint+0x69>
}
 479:	83 c4 2c             	add    $0x2c,%esp
 47c:	5b                   	pop    %ebx
 47d:	5e                   	pop    %esi
 47e:	5f                   	pop    %edi
 47f:	5d                   	pop    %ebp
 480:	c3                   	ret    
 481:	8b 75 d0             	mov    -0x30(%ebp),%esi
 484:	eb ee                	jmp    474 <printint+0x75>

00000486 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 486:	f3 0f 1e fb          	endbr32 
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	57                   	push   %edi
 48e:	56                   	push   %esi
 48f:	53                   	push   %ebx
 490:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 493:	8d 45 10             	lea    0x10(%ebp),%eax
 496:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 499:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 49e:	bb 00 00 00 00       	mov    $0x0,%ebx
 4a3:	eb 14                	jmp    4b9 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4a5:	89 fa                	mov    %edi,%edx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	e8 36 ff ff ff       	call   3e5 <putc>
 4af:	eb 05                	jmp    4b6 <printf+0x30>
      }
    } else if(state == '%'){
 4b1:	83 fe 25             	cmp    $0x25,%esi
 4b4:	74 25                	je     4db <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4b6:	83 c3 01             	add    $0x1,%ebx
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4c0:	84 c0                	test   %al,%al
 4c2:	0f 84 23 01 00 00    	je     5eb <printf+0x165>
    c = fmt[i] & 0xff;
 4c8:	0f be f8             	movsbl %al,%edi
 4cb:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4ce:	85 f6                	test   %esi,%esi
 4d0:	75 df                	jne    4b1 <printf+0x2b>
      if(c == '%'){
 4d2:	83 f8 25             	cmp    $0x25,%eax
 4d5:	75 ce                	jne    4a5 <printf+0x1f>
        state = '%';
 4d7:	89 c6                	mov    %eax,%esi
 4d9:	eb db                	jmp    4b6 <printf+0x30>
      if(c == 'd'){
 4db:	83 f8 64             	cmp    $0x64,%eax
 4de:	74 49                	je     529 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e0:	83 f8 78             	cmp    $0x78,%eax
 4e3:	0f 94 c1             	sete   %cl
 4e6:	83 f8 70             	cmp    $0x70,%eax
 4e9:	0f 94 c2             	sete   %dl
 4ec:	08 d1                	or     %dl,%cl
 4ee:	75 63                	jne    553 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f0:	83 f8 73             	cmp    $0x73,%eax
 4f3:	0f 84 84 00 00 00    	je     57d <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f9:	83 f8 63             	cmp    $0x63,%eax
 4fc:	0f 84 b7 00 00 00    	je     5b9 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 502:	83 f8 25             	cmp    $0x25,%eax
 505:	0f 84 cc 00 00 00    	je     5d7 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 50b:	ba 25 00 00 00       	mov    $0x25,%edx
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	e8 cd fe ff ff       	call   3e5 <putc>
        putc(fd, c);
 518:	89 fa                	mov    %edi,%edx
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	e8 c3 fe ff ff       	call   3e5 <putc>
      }
      state = 0;
 522:	be 00 00 00 00       	mov    $0x0,%esi
 527:	eb 8d                	jmp    4b6 <printf+0x30>
        printint(fd, *ap, 10, 1);
 529:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 52c:	8b 17                	mov    (%edi),%edx
 52e:	83 ec 0c             	sub    $0xc,%esp
 531:	6a 01                	push   $0x1
 533:	b9 0a 00 00 00       	mov    $0xa,%ecx
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	e8 bf fe ff ff       	call   3ff <printint>
        ap++;
 540:	83 c7 04             	add    $0x4,%edi
 543:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 546:	83 c4 10             	add    $0x10,%esp
      state = 0;
 549:	be 00 00 00 00       	mov    $0x0,%esi
 54e:	e9 63 ff ff ff       	jmp    4b6 <printf+0x30>
        printint(fd, *ap, 16, 0);
 553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 556:	8b 17                	mov    (%edi),%edx
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	6a 00                	push   $0x0
 55d:	b9 10 00 00 00       	mov    $0x10,%ecx
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	e8 95 fe ff ff       	call   3ff <printint>
        ap++;
 56a:	83 c7 04             	add    $0x4,%edi
 56d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 570:	83 c4 10             	add    $0x10,%esp
      state = 0;
 573:	be 00 00 00 00       	mov    $0x0,%esi
 578:	e9 39 ff ff ff       	jmp    4b6 <printf+0x30>
        s = (char*)*ap;
 57d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 580:	8b 30                	mov    (%eax),%esi
        ap++;
 582:	83 c0 04             	add    $0x4,%eax
 585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 588:	85 f6                	test   %esi,%esi
 58a:	75 28                	jne    5b4 <printf+0x12e>
          s = "(null)";
 58c:	be 58 07 00 00       	mov    $0x758,%esi
 591:	8b 7d 08             	mov    0x8(%ebp),%edi
 594:	eb 0d                	jmp    5a3 <printf+0x11d>
          putc(fd, *s);
 596:	0f be d2             	movsbl %dl,%edx
 599:	89 f8                	mov    %edi,%eax
 59b:	e8 45 fe ff ff       	call   3e5 <putc>
          s++;
 5a0:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5a3:	0f b6 16             	movzbl (%esi),%edx
 5a6:	84 d2                	test   %dl,%dl
 5a8:	75 ec                	jne    596 <printf+0x110>
      state = 0;
 5aa:	be 00 00 00 00       	mov    $0x0,%esi
 5af:	e9 02 ff ff ff       	jmp    4b6 <printf+0x30>
 5b4:	8b 7d 08             	mov    0x8(%ebp),%edi
 5b7:	eb ea                	jmp    5a3 <printf+0x11d>
        putc(fd, *ap);
 5b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5bc:	0f be 17             	movsbl (%edi),%edx
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	e8 1e fe ff ff       	call   3e5 <putc>
        ap++;
 5c7:	83 c7 04             	add    $0x4,%edi
 5ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5cd:	be 00 00 00 00       	mov    $0x0,%esi
 5d2:	e9 df fe ff ff       	jmp    4b6 <printf+0x30>
        putc(fd, c);
 5d7:	89 fa                	mov    %edi,%edx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	e8 04 fe ff ff       	call   3e5 <putc>
      state = 0;
 5e1:	be 00 00 00 00       	mov    $0x0,%esi
 5e6:	e9 cb fe ff ff       	jmp    4b6 <printf+0x30>
    }
  }
}
 5eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ee:	5b                   	pop    %ebx
 5ef:	5e                   	pop    %esi
 5f0:	5f                   	pop    %edi
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret    

000005f3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f3:	f3 0f 1e fb          	endbr32 
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
 5fa:	57                   	push   %edi
 5fb:	56                   	push   %esi
 5fc:	53                   	push   %ebx
 5fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 600:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 603:	a1 68 0a 00 00       	mov    0xa68,%eax
 608:	eb 02                	jmp    60c <free+0x19>
 60a:	89 d0                	mov    %edx,%eax
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	73 04                	jae    614 <free+0x21>
 610:	39 08                	cmp    %ecx,(%eax)
 612:	77 12                	ja     626 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 614:	8b 10                	mov    (%eax),%edx
 616:	39 c2                	cmp    %eax,%edx
 618:	77 f0                	ja     60a <free+0x17>
 61a:	39 c8                	cmp    %ecx,%eax
 61c:	72 08                	jb     626 <free+0x33>
 61e:	39 ca                	cmp    %ecx,%edx
 620:	77 04                	ja     626 <free+0x33>
 622:	89 d0                	mov    %edx,%eax
 624:	eb e6                	jmp    60c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 626:	8b 73 fc             	mov    -0x4(%ebx),%esi
 629:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62c:	8b 10                	mov    (%eax),%edx
 62e:	39 d7                	cmp    %edx,%edi
 630:	74 19                	je     64b <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 632:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 635:	8b 50 04             	mov    0x4(%eax),%edx
 638:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63b:	39 ce                	cmp    %ecx,%esi
 63d:	74 1b                	je     65a <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 63f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 641:	a3 68 0a 00 00       	mov    %eax,0xa68
}
 646:	5b                   	pop    %ebx
 647:	5e                   	pop    %esi
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 64b:	03 72 04             	add    0x4(%edx),%esi
 64e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 651:	8b 10                	mov    (%eax),%edx
 653:	8b 12                	mov    (%edx),%edx
 655:	89 53 f8             	mov    %edx,-0x8(%ebx)
 658:	eb db                	jmp    635 <free+0x42>
    p->s.size += bp->s.size;
 65a:	03 53 fc             	add    -0x4(%ebx),%edx
 65d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 660:	8b 53 f8             	mov    -0x8(%ebx),%edx
 663:	89 10                	mov    %edx,(%eax)
 665:	eb da                	jmp    641 <free+0x4e>

00000667 <morecore>:

static Header*
morecore(uint nu)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	53                   	push   %ebx
 66b:	83 ec 04             	sub    $0x4,%esp
 66e:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 670:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 675:	77 05                	ja     67c <morecore+0x15>
    nu = 4096;
 677:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 67c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 683:	83 ec 0c             	sub    $0xc,%esp
 686:	50                   	push   %eax
 687:	e8 f1 fc ff ff       	call   37d <sbrk>
  if(p == (char*)-1)
 68c:	83 c4 10             	add    $0x10,%esp
 68f:	83 f8 ff             	cmp    $0xffffffff,%eax
 692:	74 1c                	je     6b0 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 694:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 697:	83 c0 08             	add    $0x8,%eax
 69a:	83 ec 0c             	sub    $0xc,%esp
 69d:	50                   	push   %eax
 69e:	e8 50 ff ff ff       	call   5f3 <free>
  return freep;
 6a3:	a1 68 0a 00 00       	mov    0xa68,%eax
 6a8:	83 c4 10             	add    $0x10,%esp
}
 6ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ae:	c9                   	leave  
 6af:	c3                   	ret    
    return 0;
 6b0:	b8 00 00 00 00       	mov    $0x0,%eax
 6b5:	eb f4                	jmp    6ab <morecore+0x44>

000006b7 <malloc>:

void*
malloc(uint nbytes)
{
 6b7:	f3 0f 1e fb          	endbr32 
 6bb:	55                   	push   %ebp
 6bc:	89 e5                	mov    %esp,%ebp
 6be:	53                   	push   %ebx
 6bf:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	8d 58 07             	lea    0x7(%eax),%ebx
 6c8:	c1 eb 03             	shr    $0x3,%ebx
 6cb:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6ce:	8b 0d 68 0a 00 00    	mov    0xa68,%ecx
 6d4:	85 c9                	test   %ecx,%ecx
 6d6:	74 04                	je     6dc <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	8b 01                	mov    (%ecx),%eax
 6da:	eb 4b                	jmp    727 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6dc:	c7 05 68 0a 00 00 6c 	movl   $0xa6c,0xa68
 6e3:	0a 00 00 
 6e6:	c7 05 6c 0a 00 00 6c 	movl   $0xa6c,0xa6c
 6ed:	0a 00 00 
    base.s.size = 0;
 6f0:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 6f7:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6fa:	b9 6c 0a 00 00       	mov    $0xa6c,%ecx
 6ff:	eb d7                	jmp    6d8 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 701:	74 1a                	je     71d <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 703:	29 da                	sub    %ebx,%edx
 705:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 708:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 70b:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 70e:	89 0d 68 0a 00 00    	mov    %ecx,0xa68
      return (void*)(p + 1);
 714:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 717:	83 c4 04             	add    $0x4,%esp
 71a:	5b                   	pop    %ebx
 71b:	5d                   	pop    %ebp
 71c:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 71d:	8b 10                	mov    (%eax),%edx
 71f:	89 11                	mov    %edx,(%ecx)
 721:	eb eb                	jmp    70e <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	89 c1                	mov    %eax,%ecx
 725:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 727:	8b 50 04             	mov    0x4(%eax),%edx
 72a:	39 da                	cmp    %ebx,%edx
 72c:	73 d3                	jae    701 <malloc+0x4a>
    if(p == freep)
 72e:	39 05 68 0a 00 00    	cmp    %eax,0xa68
 734:	75 ed                	jne    723 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 736:	89 d8                	mov    %ebx,%eax
 738:	e8 2a ff ff ff       	call   667 <morecore>
 73d:	85 c0                	test   %eax,%eax
 73f:	75 e2                	jne    723 <malloc+0x6c>
 741:	eb d4                	jmp    717 <malloc+0x60>
