
_testsetuid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
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
  11:	53                   	push   %ebx
  12:	51                   	push   %ecx
  13:	8b 59 04             	mov    0x4(%ecx),%ebx
  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  16:	e8 5a 03 00 00       	call   375 <getuid>
  1b:	50                   	push   %eax
  1c:	ff 33                	pushl  (%ebx)
  1e:	68 14 07 00 00       	push   $0x714
  23:	6a 01                	push   $0x1
  25:	e8 2c 04 00 00       	call   456 <printf>
  exit();
  2a:	e8 96 02 00 00       	call   2c5 <exit>

0000002f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  2f:	f3 0f 1e fb          	endbr32 
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	56                   	push   %esi
  37:	53                   	push   %ebx
  38:	8b 75 08             	mov    0x8(%ebp),%esi
  3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3e:	89 f0                	mov    %esi,%eax
  40:	89 d1                	mov    %edx,%ecx
  42:	83 c2 01             	add    $0x1,%edx
  45:	89 c3                	mov    %eax,%ebx
  47:	83 c0 01             	add    $0x1,%eax
  4a:	0f b6 09             	movzbl (%ecx),%ecx
  4d:	88 0b                	mov    %cl,(%ebx)
  4f:	84 c9                	test   %cl,%cl
  51:	75 ed                	jne    40 <strcpy+0x11>
    ;
  return os;
}
  53:	89 f0                	mov    %esi,%eax
  55:	5b                   	pop    %ebx
  56:	5e                   	pop    %esi
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  59:	f3 0f 1e fb          	endbr32 
  5d:	55                   	push   %ebp
  5e:	89 e5                	mov    %esp,%ebp
  60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  63:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  66:	0f b6 01             	movzbl (%ecx),%eax
  69:	84 c0                	test   %al,%al
  6b:	74 0c                	je     79 <strcmp+0x20>
  6d:	3a 02                	cmp    (%edx),%al
  6f:	75 08                	jne    79 <strcmp+0x20>
    p++, q++;
  71:	83 c1 01             	add    $0x1,%ecx
  74:	83 c2 01             	add    $0x1,%edx
  77:	eb ed                	jmp    66 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  79:	0f b6 c0             	movzbl %al,%eax
  7c:	0f b6 12             	movzbl (%edx),%edx
  7f:	29 d0                	sub    %edx,%eax
}
  81:	5d                   	pop    %ebp
  82:	c3                   	ret    

00000083 <strlen>:

uint
strlen(char *s)
{
  83:	f3 0f 1e fb          	endbr32 
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  8d:	b8 00 00 00 00       	mov    $0x0,%eax
  92:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  96:	74 05                	je     9d <strlen+0x1a>
  98:	83 c0 01             	add    $0x1,%eax
  9b:	eb f5                	jmp    92 <strlen+0xf>
    ;
  return n;
}
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <memset>:

void*
memset(void *dst, int c, uint n)
{
  9f:	f3 0f 1e fb          	endbr32 
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	57                   	push   %edi
  a7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  aa:	89 d7                	mov    %edx,%edi
  ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  af:	8b 45 0c             	mov    0xc(%ebp),%eax
  b2:	fc                   	cld    
  b3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b5:	89 d0                	mov    %edx,%eax
  b7:	5f                   	pop    %edi
  b8:	5d                   	pop    %ebp
  b9:	c3                   	ret    

000000ba <strchr>:

char*
strchr(const char *s, char c)
{
  ba:	f3 0f 1e fb          	endbr32 
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  c8:	0f b6 10             	movzbl (%eax),%edx
  cb:	84 d2                	test   %dl,%dl
  cd:	74 09                	je     d8 <strchr+0x1e>
    if(*s == c)
  cf:	38 ca                	cmp    %cl,%dl
  d1:	74 0a                	je     dd <strchr+0x23>
  for(; *s; s++)
  d3:	83 c0 01             	add    $0x1,%eax
  d6:	eb f0                	jmp    c8 <strchr+0xe>
      return (char*)s;
  return 0;
  d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    

000000df <gets>:

char*
gets(char *buf, int max)
{
  df:	f3 0f 1e fb          	endbr32 
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	57                   	push   %edi
  e7:	56                   	push   %esi
  e8:	53                   	push   %ebx
  e9:	83 ec 1c             	sub    $0x1c,%esp
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  f4:	89 de                	mov    %ebx,%esi
  f6:	83 c3 01             	add    $0x1,%ebx
  f9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  fc:	7d 2e                	jge    12c <gets+0x4d>
    cc = read(0, &c, 1);
  fe:	83 ec 04             	sub    $0x4,%esp
 101:	6a 01                	push   $0x1
 103:	8d 45 e7             	lea    -0x19(%ebp),%eax
 106:	50                   	push   %eax
 107:	6a 00                	push   $0x0
 109:	e8 cf 01 00 00       	call   2dd <read>
    if(cc < 1)
 10e:	83 c4 10             	add    $0x10,%esp
 111:	85 c0                	test   %eax,%eax
 113:	7e 17                	jle    12c <gets+0x4d>
      break;
    buf[i++] = c;
 115:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 119:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11c:	3c 0a                	cmp    $0xa,%al
 11e:	0f 94 c2             	sete   %dl
 121:	3c 0d                	cmp    $0xd,%al
 123:	0f 94 c0             	sete   %al
 126:	08 c2                	or     %al,%dl
 128:	74 ca                	je     f4 <gets+0x15>
    buf[i++] = c;
 12a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 130:	89 f8                	mov    %edi,%eax
 132:	8d 65 f4             	lea    -0xc(%ebp),%esp
 135:	5b                   	pop    %ebx
 136:	5e                   	pop    %esi
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <stat>:

int
stat(char *n, struct stat *st)
{
 13a:	f3 0f 1e fb          	endbr32 
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	56                   	push   %esi
 142:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 143:	83 ec 08             	sub    $0x8,%esp
 146:	6a 00                	push   $0x0
 148:	ff 75 08             	pushl  0x8(%ebp)
 14b:	e8 b5 01 00 00       	call   305 <open>
  if(fd < 0)
 150:	83 c4 10             	add    $0x10,%esp
 153:	85 c0                	test   %eax,%eax
 155:	78 24                	js     17b <stat+0x41>
 157:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 159:	83 ec 08             	sub    $0x8,%esp
 15c:	ff 75 0c             	pushl  0xc(%ebp)
 15f:	50                   	push   %eax
 160:	e8 b8 01 00 00       	call   31d <fstat>
 165:	89 c6                	mov    %eax,%esi
  close(fd);
 167:	89 1c 24             	mov    %ebx,(%esp)
 16a:	e8 7e 01 00 00       	call   2ed <close>
  return r;
 16f:	83 c4 10             	add    $0x10,%esp
}
 172:	89 f0                	mov    %esi,%eax
 174:	8d 65 f8             	lea    -0x8(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
    return -1;
 17b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 180:	eb f0                	jmp    172 <stat+0x38>

00000182 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 182:	f3 0f 1e fb          	endbr32 
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	57                   	push   %edi
 18a:	56                   	push   %esi
 18b:	53                   	push   %ebx
 18c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 18f:	0f b6 02             	movzbl (%edx),%eax
 192:	3c 20                	cmp    $0x20,%al
 194:	75 05                	jne    19b <atoi+0x19>
 196:	83 c2 01             	add    $0x1,%edx
 199:	eb f4                	jmp    18f <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 19b:	3c 2d                	cmp    $0x2d,%al
 19d:	74 1d                	je     1bc <atoi+0x3a>
 19f:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1a4:	3c 2b                	cmp    $0x2b,%al
 1a6:	0f 94 c1             	sete   %cl
 1a9:	3c 2d                	cmp    $0x2d,%al
 1ab:	0f 94 c0             	sete   %al
 1ae:	08 c1                	or     %al,%cl
 1b0:	74 03                	je     1b5 <atoi+0x33>
    s++;
 1b2:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1b5:	b8 00 00 00 00       	mov    $0x0,%eax
 1ba:	eb 17                	jmp    1d3 <atoi+0x51>
 1bc:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1c1:	eb e1                	jmp    1a4 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1c3:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1c6:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1c9:	83 c2 01             	add    $0x1,%edx
 1cc:	0f be c9             	movsbl %cl,%ecx
 1cf:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1d3:	0f b6 0a             	movzbl (%edx),%ecx
 1d6:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1d9:	80 fb 09             	cmp    $0x9,%bl
 1dc:	76 e5                	jbe    1c3 <atoi+0x41>
  return sign*n;
 1de:	0f af c7             	imul   %edi,%eax
}
 1e1:	5b                   	pop    %ebx
 1e2:	5e                   	pop    %esi
 1e3:	5f                   	pop    %edi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <atoo>:

int
atoo(const char *s)
{
 1e6:	f3 0f 1e fb          	endbr32 
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	57                   	push   %edi
 1ee:	56                   	push   %esi
 1ef:	53                   	push   %ebx
 1f0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f3:	0f b6 0a             	movzbl (%edx),%ecx
 1f6:	80 f9 20             	cmp    $0x20,%cl
 1f9:	75 05                	jne    200 <atoo+0x1a>
 1fb:	83 c2 01             	add    $0x1,%edx
 1fe:	eb f3                	jmp    1f3 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 200:	80 f9 2d             	cmp    $0x2d,%cl
 203:	74 23                	je     228 <atoo+0x42>
 205:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 20a:	80 f9 2b             	cmp    $0x2b,%cl
 20d:	0f 94 c0             	sete   %al
 210:	89 c6                	mov    %eax,%esi
 212:	80 f9 2d             	cmp    $0x2d,%cl
 215:	0f 94 c0             	sete   %al
 218:	89 f3                	mov    %esi,%ebx
 21a:	08 c3                	or     %al,%bl
 21c:	74 03                	je     221 <atoo+0x3b>
    s++;
 21e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 221:	b8 00 00 00 00       	mov    $0x0,%eax
 226:	eb 11                	jmp    239 <atoo+0x53>
 228:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 22d:	eb db                	jmp    20a <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 22f:	83 c2 01             	add    $0x1,%edx
 232:	0f be c9             	movsbl %cl,%ecx
 235:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 239:	0f b6 0a             	movzbl (%edx),%ecx
 23c:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 23f:	80 fb 07             	cmp    $0x7,%bl
 242:	76 eb                	jbe    22f <atoo+0x49>
  return sign*n;
 244:	0f af c7             	imul   %edi,%eax
}
 247:	5b                   	pop    %ebx
 248:	5e                   	pop    %esi
 249:	5f                   	pop    %edi
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    

0000024c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 24c:	f3 0f 1e fb          	endbr32 
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
 257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 25d:	eb 09                	jmp    268 <strncmp+0x1c>
      n--, p++, q++;
 25f:	83 e8 01             	sub    $0x1,%eax
 262:	83 c2 01             	add    $0x1,%edx
 265:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 268:	85 c0                	test   %eax,%eax
 26a:	74 0b                	je     277 <strncmp+0x2b>
 26c:	0f b6 1a             	movzbl (%edx),%ebx
 26f:	84 db                	test   %bl,%bl
 271:	74 04                	je     277 <strncmp+0x2b>
 273:	3a 19                	cmp    (%ecx),%bl
 275:	74 e8                	je     25f <strncmp+0x13>
    if(n == 0)
 277:	85 c0                	test   %eax,%eax
 279:	74 0b                	je     286 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 27b:	0f b6 02             	movzbl (%edx),%eax
 27e:	0f b6 11             	movzbl (%ecx),%edx
 281:	29 d0                	sub    %edx,%eax
}
 283:	5b                   	pop    %ebx
 284:	5d                   	pop    %ebp
 285:	c3                   	ret    
      return 0;
 286:	b8 00 00 00 00       	mov    $0x0,%eax
 28b:	eb f6                	jmp    283 <strncmp+0x37>

0000028d <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 28d:	f3 0f 1e fb          	endbr32 
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	56                   	push   %esi
 295:	53                   	push   %ebx
 296:	8b 75 08             	mov    0x8(%ebp),%esi
 299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 29c:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 29f:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2a4:	85 c0                	test   %eax,%eax
 2a6:	7e 0f                	jle    2b7 <memmove+0x2a>
    *dst++ = *src++;
 2a8:	0f b6 01             	movzbl (%ecx),%eax
 2ab:	88 02                	mov    %al,(%edx)
 2ad:	8d 49 01             	lea    0x1(%ecx),%ecx
 2b0:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2b3:	89 d8                	mov    %ebx,%eax
 2b5:	eb ea                	jmp    2a1 <memmove+0x14>
  return vdst;
}
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    

000002bd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bd:	b8 01 00 00 00       	mov    $0x1,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <exit>:
SYSCALL(exit)
 2c5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <wait>:
SYSCALL(wait)
 2cd:	b8 03 00 00 00       	mov    $0x3,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <pipe>:
SYSCALL(pipe)
 2d5:	b8 04 00 00 00       	mov    $0x4,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <read>:
SYSCALL(read)
 2dd:	b8 05 00 00 00       	mov    $0x5,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <write>:
SYSCALL(write)
 2e5:	b8 10 00 00 00       	mov    $0x10,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <close>:
SYSCALL(close)
 2ed:	b8 15 00 00 00       	mov    $0x15,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <kill>:
SYSCALL(kill)
 2f5:	b8 06 00 00 00       	mov    $0x6,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <exec>:
SYSCALL(exec)
 2fd:	b8 07 00 00 00       	mov    $0x7,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <open>:
SYSCALL(open)
 305:	b8 0f 00 00 00       	mov    $0xf,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <mknod>:
SYSCALL(mknod)
 30d:	b8 11 00 00 00       	mov    $0x11,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <unlink>:
SYSCALL(unlink)
 315:	b8 12 00 00 00       	mov    $0x12,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <fstat>:
SYSCALL(fstat)
 31d:	b8 08 00 00 00       	mov    $0x8,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <link>:
SYSCALL(link)
 325:	b8 13 00 00 00       	mov    $0x13,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <mkdir>:
SYSCALL(mkdir)
 32d:	b8 14 00 00 00       	mov    $0x14,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <chdir>:
SYSCALL(chdir)
 335:	b8 09 00 00 00       	mov    $0x9,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <dup>:
SYSCALL(dup)
 33d:	b8 0a 00 00 00       	mov    $0xa,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <getpid>:
SYSCALL(getpid)
 345:	b8 0b 00 00 00       	mov    $0xb,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <sbrk>:
SYSCALL(sbrk)
 34d:	b8 0c 00 00 00       	mov    $0xc,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <sleep>:
SYSCALL(sleep)
 355:	b8 0d 00 00 00       	mov    $0xd,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <uptime>:
SYSCALL(uptime)
 35d:	b8 0e 00 00 00       	mov    $0xe,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <halt>:
SYSCALL(halt)
 365:	b8 16 00 00 00       	mov    $0x16,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <date>:
SYSCALL(date)
 36d:	b8 17 00 00 00       	mov    $0x17,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getuid>:
SYSCALL(getuid)
 375:	b8 18 00 00 00       	mov    $0x18,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <getgid>:
SYSCALL(getgid)
 37d:	b8 19 00 00 00       	mov    $0x19,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <getppid>:
SYSCALL(getppid)
 385:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <setuid>:
SYSCALL(setuid)
 38d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <setgid>:
SYSCALL(setgid)
 395:	b8 1c 00 00 00       	mov    $0x1c,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <getprocs>:
SYSCALL(getprocs)
 39d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <setpriority>:
SYSCALL(setpriority)
 3a5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <getpriority>:
SYSCALL(getpriority)
 3ad:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 1c             	sub    $0x1c,%esp
 3bb:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3be:	6a 01                	push   $0x1
 3c0:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3c3:	52                   	push   %edx
 3c4:	50                   	push   %eax
 3c5:	e8 1b ff ff ff       	call   2e5 <write>
}
 3ca:	83 c4 10             	add    $0x10,%esp
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	57                   	push   %edi
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	83 ec 2c             	sub    $0x2c,%esp
 3d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3db:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3e1:	0f 95 c2             	setne  %dl
 3e4:	89 f0                	mov    %esi,%eax
 3e6:	c1 e8 1f             	shr    $0x1f,%eax
 3e9:	84 c2                	test   %al,%dl
 3eb:	74 42                	je     42f <printint+0x60>
    neg = 1;
    x = -xx;
 3ed:	f7 de                	neg    %esi
    neg = 1;
 3ef:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3fb:	89 f0                	mov    %esi,%eax
 3fd:	ba 00 00 00 00       	mov    $0x0,%edx
 402:	f7 f1                	div    %ecx
 404:	89 df                	mov    %ebx,%edi
 406:	83 c3 01             	add    $0x1,%ebx
 409:	0f b6 92 38 07 00 00 	movzbl 0x738(%edx),%edx
 410:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 414:	89 f2                	mov    %esi,%edx
 416:	89 c6                	mov    %eax,%esi
 418:	39 d1                	cmp    %edx,%ecx
 41a:	76 df                	jbe    3fb <printint+0x2c>
  if(neg)
 41c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 420:	74 2f                	je     451 <printint+0x82>
    buf[i++] = '-';
 422:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 427:	8d 5f 02             	lea    0x2(%edi),%ebx
 42a:	8b 75 d0             	mov    -0x30(%ebp),%esi
 42d:	eb 15                	jmp    444 <printint+0x75>
  neg = 0;
 42f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 436:	eb be                	jmp    3f6 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 438:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 43d:	89 f0                	mov    %esi,%eax
 43f:	e8 71 ff ff ff       	call   3b5 <putc>
  while(--i >= 0)
 444:	83 eb 01             	sub    $0x1,%ebx
 447:	79 ef                	jns    438 <printint+0x69>
}
 449:	83 c4 2c             	add    $0x2c,%esp
 44c:	5b                   	pop    %ebx
 44d:	5e                   	pop    %esi
 44e:	5f                   	pop    %edi
 44f:	5d                   	pop    %ebp
 450:	c3                   	ret    
 451:	8b 75 d0             	mov    -0x30(%ebp),%esi
 454:	eb ee                	jmp    444 <printint+0x75>

00000456 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 456:	f3 0f 1e fb          	endbr32 
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	57                   	push   %edi
 45e:	56                   	push   %esi
 45f:	53                   	push   %ebx
 460:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 463:	8d 45 10             	lea    0x10(%ebp),%eax
 466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 469:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 46e:	bb 00 00 00 00       	mov    $0x0,%ebx
 473:	eb 14                	jmp    489 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 475:	89 fa                	mov    %edi,%edx
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	e8 36 ff ff ff       	call   3b5 <putc>
 47f:	eb 05                	jmp    486 <printf+0x30>
      }
    } else if(state == '%'){
 481:	83 fe 25             	cmp    $0x25,%esi
 484:	74 25                	je     4ab <printf+0x55>
  for(i = 0; fmt[i]; i++){
 486:	83 c3 01             	add    $0x1,%ebx
 489:	8b 45 0c             	mov    0xc(%ebp),%eax
 48c:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 490:	84 c0                	test   %al,%al
 492:	0f 84 23 01 00 00    	je     5bb <printf+0x165>
    c = fmt[i] & 0xff;
 498:	0f be f8             	movsbl %al,%edi
 49b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 49e:	85 f6                	test   %esi,%esi
 4a0:	75 df                	jne    481 <printf+0x2b>
      if(c == '%'){
 4a2:	83 f8 25             	cmp    $0x25,%eax
 4a5:	75 ce                	jne    475 <printf+0x1f>
        state = '%';
 4a7:	89 c6                	mov    %eax,%esi
 4a9:	eb db                	jmp    486 <printf+0x30>
      if(c == 'd'){
 4ab:	83 f8 64             	cmp    $0x64,%eax
 4ae:	74 49                	je     4f9 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4b0:	83 f8 78             	cmp    $0x78,%eax
 4b3:	0f 94 c1             	sete   %cl
 4b6:	83 f8 70             	cmp    $0x70,%eax
 4b9:	0f 94 c2             	sete   %dl
 4bc:	08 d1                	or     %dl,%cl
 4be:	75 63                	jne    523 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c0:	83 f8 73             	cmp    $0x73,%eax
 4c3:	0f 84 84 00 00 00    	je     54d <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c9:	83 f8 63             	cmp    $0x63,%eax
 4cc:	0f 84 b7 00 00 00    	je     589 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d2:	83 f8 25             	cmp    $0x25,%eax
 4d5:	0f 84 cc 00 00 00    	je     5a7 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4db:	ba 25 00 00 00       	mov    $0x25,%edx
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	e8 cd fe ff ff       	call   3b5 <putc>
        putc(fd, c);
 4e8:	89 fa                	mov    %edi,%edx
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	e8 c3 fe ff ff       	call   3b5 <putc>
      }
      state = 0;
 4f2:	be 00 00 00 00       	mov    $0x0,%esi
 4f7:	eb 8d                	jmp    486 <printf+0x30>
        printint(fd, *ap, 10, 1);
 4f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4fc:	8b 17                	mov    (%edi),%edx
 4fe:	83 ec 0c             	sub    $0xc,%esp
 501:	6a 01                	push   $0x1
 503:	b9 0a 00 00 00       	mov    $0xa,%ecx
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	e8 bf fe ff ff       	call   3cf <printint>
        ap++;
 510:	83 c7 04             	add    $0x4,%edi
 513:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 516:	83 c4 10             	add    $0x10,%esp
      state = 0;
 519:	be 00 00 00 00       	mov    $0x0,%esi
 51e:	e9 63 ff ff ff       	jmp    486 <printf+0x30>
        printint(fd, *ap, 16, 0);
 523:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 526:	8b 17                	mov    (%edi),%edx
 528:	83 ec 0c             	sub    $0xc,%esp
 52b:	6a 00                	push   $0x0
 52d:	b9 10 00 00 00       	mov    $0x10,%ecx
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	e8 95 fe ff ff       	call   3cf <printint>
        ap++;
 53a:	83 c7 04             	add    $0x4,%edi
 53d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 540:	83 c4 10             	add    $0x10,%esp
      state = 0;
 543:	be 00 00 00 00       	mov    $0x0,%esi
 548:	e9 39 ff ff ff       	jmp    486 <printf+0x30>
        s = (char*)*ap;
 54d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 550:	8b 30                	mov    (%eax),%esi
        ap++;
 552:	83 c0 04             	add    $0x4,%eax
 555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 558:	85 f6                	test   %esi,%esi
 55a:	75 28                	jne    584 <printf+0x12e>
          s = "(null)";
 55c:	be 30 07 00 00       	mov    $0x730,%esi
 561:	8b 7d 08             	mov    0x8(%ebp),%edi
 564:	eb 0d                	jmp    573 <printf+0x11d>
          putc(fd, *s);
 566:	0f be d2             	movsbl %dl,%edx
 569:	89 f8                	mov    %edi,%eax
 56b:	e8 45 fe ff ff       	call   3b5 <putc>
          s++;
 570:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 573:	0f b6 16             	movzbl (%esi),%edx
 576:	84 d2                	test   %dl,%dl
 578:	75 ec                	jne    566 <printf+0x110>
      state = 0;
 57a:	be 00 00 00 00       	mov    $0x0,%esi
 57f:	e9 02 ff ff ff       	jmp    486 <printf+0x30>
 584:	8b 7d 08             	mov    0x8(%ebp),%edi
 587:	eb ea                	jmp    573 <printf+0x11d>
        putc(fd, *ap);
 589:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 58c:	0f be 17             	movsbl (%edi),%edx
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	e8 1e fe ff ff       	call   3b5 <putc>
        ap++;
 597:	83 c7 04             	add    $0x4,%edi
 59a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 59d:	be 00 00 00 00       	mov    $0x0,%esi
 5a2:	e9 df fe ff ff       	jmp    486 <printf+0x30>
        putc(fd, c);
 5a7:	89 fa                	mov    %edi,%edx
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	e8 04 fe ff ff       	call   3b5 <putc>
      state = 0;
 5b1:	be 00 00 00 00       	mov    $0x0,%esi
 5b6:	e9 cb fe ff ff       	jmp    486 <printf+0x30>
    }
  }
}
 5bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5be:	5b                   	pop    %ebx
 5bf:	5e                   	pop    %esi
 5c0:	5f                   	pop    %edi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    

000005c3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c3:	f3 0f 1e fb          	endbr32 
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	57                   	push   %edi
 5cb:	56                   	push   %esi
 5cc:	53                   	push   %ebx
 5cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d3:	a1 38 0a 00 00       	mov    0xa38,%eax
 5d8:	eb 02                	jmp    5dc <free+0x19>
 5da:	89 d0                	mov    %edx,%eax
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	73 04                	jae    5e4 <free+0x21>
 5e0:	39 08                	cmp    %ecx,(%eax)
 5e2:	77 12                	ja     5f6 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e4:	8b 10                	mov    (%eax),%edx
 5e6:	39 c2                	cmp    %eax,%edx
 5e8:	77 f0                	ja     5da <free+0x17>
 5ea:	39 c8                	cmp    %ecx,%eax
 5ec:	72 08                	jb     5f6 <free+0x33>
 5ee:	39 ca                	cmp    %ecx,%edx
 5f0:	77 04                	ja     5f6 <free+0x33>
 5f2:	89 d0                	mov    %edx,%eax
 5f4:	eb e6                	jmp    5dc <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fc:	8b 10                	mov    (%eax),%edx
 5fe:	39 d7                	cmp    %edx,%edi
 600:	74 19                	je     61b <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 602:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 605:	8b 50 04             	mov    0x4(%eax),%edx
 608:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 60b:	39 ce                	cmp    %ecx,%esi
 60d:	74 1b                	je     62a <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 60f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 611:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 616:	5b                   	pop    %ebx
 617:	5e                   	pop    %esi
 618:	5f                   	pop    %edi
 619:	5d                   	pop    %ebp
 61a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 61b:	03 72 04             	add    0x4(%edx),%esi
 61e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 621:	8b 10                	mov    (%eax),%edx
 623:	8b 12                	mov    (%edx),%edx
 625:	89 53 f8             	mov    %edx,-0x8(%ebx)
 628:	eb db                	jmp    605 <free+0x42>
    p->s.size += bp->s.size;
 62a:	03 53 fc             	add    -0x4(%ebx),%edx
 62d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 630:	8b 53 f8             	mov    -0x8(%ebx),%edx
 633:	89 10                	mov    %edx,(%eax)
 635:	eb da                	jmp    611 <free+0x4e>

00000637 <morecore>:

static Header*
morecore(uint nu)
{
 637:	55                   	push   %ebp
 638:	89 e5                	mov    %esp,%ebp
 63a:	53                   	push   %ebx
 63b:	83 ec 04             	sub    $0x4,%esp
 63e:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 640:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 645:	77 05                	ja     64c <morecore+0x15>
    nu = 4096;
 647:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 64c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	50                   	push   %eax
 657:	e8 f1 fc ff ff       	call   34d <sbrk>
  if(p == (char*)-1)
 65c:	83 c4 10             	add    $0x10,%esp
 65f:	83 f8 ff             	cmp    $0xffffffff,%eax
 662:	74 1c                	je     680 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 664:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 667:	83 c0 08             	add    $0x8,%eax
 66a:	83 ec 0c             	sub    $0xc,%esp
 66d:	50                   	push   %eax
 66e:	e8 50 ff ff ff       	call   5c3 <free>
  return freep;
 673:	a1 38 0a 00 00       	mov    0xa38,%eax
 678:	83 c4 10             	add    $0x10,%esp
}
 67b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 67e:	c9                   	leave  
 67f:	c3                   	ret    
    return 0;
 680:	b8 00 00 00 00       	mov    $0x0,%eax
 685:	eb f4                	jmp    67b <morecore+0x44>

00000687 <malloc>:

void*
malloc(uint nbytes)
{
 687:	f3 0f 1e fb          	endbr32 
 68b:	55                   	push   %ebp
 68c:	89 e5                	mov    %esp,%ebp
 68e:	53                   	push   %ebx
 68f:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	8d 58 07             	lea    0x7(%eax),%ebx
 698:	c1 eb 03             	shr    $0x3,%ebx
 69b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 69e:	8b 0d 38 0a 00 00    	mov    0xa38,%ecx
 6a4:	85 c9                	test   %ecx,%ecx
 6a6:	74 04                	je     6ac <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a8:	8b 01                	mov    (%ecx),%eax
 6aa:	eb 4b                	jmp    6f7 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6ac:	c7 05 38 0a 00 00 3c 	movl   $0xa3c,0xa38
 6b3:	0a 00 00 
 6b6:	c7 05 3c 0a 00 00 3c 	movl   $0xa3c,0xa3c
 6bd:	0a 00 00 
    base.s.size = 0;
 6c0:	c7 05 40 0a 00 00 00 	movl   $0x0,0xa40
 6c7:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6ca:	b9 3c 0a 00 00       	mov    $0xa3c,%ecx
 6cf:	eb d7                	jmp    6a8 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6d1:	74 1a                	je     6ed <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6d3:	29 da                	sub    %ebx,%edx
 6d5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6d8:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6db:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6de:	89 0d 38 0a 00 00    	mov    %ecx,0xa38
      return (void*)(p + 1);
 6e4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6e7:	83 c4 04             	add    $0x4,%esp
 6ea:	5b                   	pop    %ebx
 6eb:	5d                   	pop    %ebp
 6ec:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	89 11                	mov    %edx,(%ecx)
 6f1:	eb eb                	jmp    6de <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f3:	89 c1                	mov    %eax,%ecx
 6f5:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6f7:	8b 50 04             	mov    0x4(%eax),%edx
 6fa:	39 da                	cmp    %ebx,%edx
 6fc:	73 d3                	jae    6d1 <malloc+0x4a>
    if(p == freep)
 6fe:	39 05 38 0a 00 00    	cmp    %eax,0xa38
 704:	75 ed                	jne    6f3 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 706:	89 d8                	mov    %ebx,%eax
 708:	e8 2a ff ff ff       	call   637 <morecore>
 70d:	85 c0                	test   %eax,%eax
 70f:	75 e2                	jne    6f3 <malloc+0x6c>
 711:	eb d4                	jmp    6e7 <malloc+0x60>
