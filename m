Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6231D10FC93
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2019 12:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfLCLkE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Dec 2019 06:40:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38778 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCLkE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Dec 2019 06:40:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so1732531pfc.5;
        Tue, 03 Dec 2019 03:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LdKkOlOJHruNAMRVN3m7zzds2dYKsN5d406veskx7yU=;
        b=q/DvUl8tjGDzbwPvT9us5ksb3dUNHp/WL1RbalFOp8gSFlb2/aaU5zvwkxzVZQ09x8
         sDVPYVpEiUry2maSH4/+eLdyC1LxbmLayjAN0F3lYmgNCgVXP/SAWOFaJFnv2aRgRfvH
         MiF7yNpPP836EmC0+WHTkNUl0NFal0yQrJKO5BPEPFeEVa822NjEBxhQfs/deV2Sq8gN
         UE4yNQJ4qVJLKPImP/ZLr9MLuelh9aqd0WVzrjZmmx6c46pircwV97VZOfHTgRMn5HlC
         oOcgrfbTHXBL8FK5+jbi3kad83cUI1vfL/uQf+MRYnR0N0LO9pLVKwH9gnS8jcmP2KE/
         WRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LdKkOlOJHruNAMRVN3m7zzds2dYKsN5d406veskx7yU=;
        b=JHlibeSdEpy8GTyrseOjbOantAs+FFtuHZw9QcS6jqr6rM985oWzXY9ybTl9h0qAN8
         BuFCMQZyldUvbSxWX5CFNgsV+sCg8iGTZAJr7JRQqvCLKohw+tmsDmjvHbLOcyUrs7hI
         Dpz9c+J/aMw570ejyQfMQKo48kgCb8WGA+Ywx2WCcai58j0t4pTM5kNW4TUtyWWt24aJ
         zSA83/dhYXUSiAB7dLJOhUfUA21HvnY0x/4Dzt+bb41JKNXoVMKspi3AFVdxWgL9UR3u
         8rsO3ubvIJQ9/Jco3rFIekjw5Q9majcCttzsBPfzvpB7dCGXl1300TRwG/1cpZX8Hctl
         bOGg==
X-Gm-Message-State: APjAAAWNoHSRpb5/c42aQcc+yH0rADa6sEPlzsfU/ozapw5zjyvBTDVG
        aGeRgrhv6QVBGH0+ubvefnY=
X-Google-Smtp-Source: APXvYqx8dgfUh7P0sym8yzt6bWxKVT1O3GxDyYPl/DOmSQmShGtOGO2G75wBy78b8pJuZMCl52g4Qw==
X-Received: by 2002:a63:da47:: with SMTP id l7mr4897956pgj.34.1575373203417;
        Tue, 03 Dec 2019 03:40:03 -0800 (PST)
Received: from wangyang5-l1.corp.qihoo.net ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id m7sm3325358pgh.72.2019.12.03.03.39.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 03:40:02 -0800 (PST)
Date:   Tue, 3 Dec 2019 19:39:56 +0800
From:   kungf <wings.wyang@gmail.com>
To:     Coly Li <colyli@suse.de>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback
 mode
Message-Id: <20191203193956.fe0ab4c2ec7eba4e55a3de89@gmail.com>
In-Reply-To: <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
References: <20191202102409.3980-1-wings.wyang@gmail.com>
        <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.30; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 2 Dec 2019 19:08:59 +0800
Coly Li <colyli@suse.de> wrote:

> On 2019/12/2 6:24 pm, kungf wrote:
> > data may lost when in the follow scene of writeback mode:
> > 1. client write data1 to bcache
> > 2. client fdatasync
> > 3. bcache flush cache set and backing device
> > if now data1 was not writed back to backing, it was only guaranteed saf=
e in cache.
> > 4.then cache writeback data1 to backing with only REQ_OP_WRITE
> > So data1 was not guaranteed in non-volatile storage,  it may lost if  p=
ower interruption=A0
> >=20
>=20
> Hi,
>=20
> Do you encounter such problem in real work load ? With bcache journal, I
> don't see the possibility of data lost with your description.
>=20
> Correct me if I am wrong.
>=20
> Coly Li

Hi Coly?

Sorry to confuse you. As i known now, write_dirty function write dirty to b=
acking without FUA, and write_dirty_finish make dirty key clean,
it means the data indexed by the key will not be writeback again, am i wron=
g?
I only find that the backing device will be flushed when bcache get an PREF=
LUSH bio, any other place  it will be flushed in journal?

I made a test that write bcache with dd, and then detach it, blktrace the c=
ache and backing device at the same time.
1. close writeback
# echo 0 > /sys/block/bcache0/bcache/writeback_running
2. write data with a fdatasync
#dd if=3D/dev/zero of=3D/dev/bcache0 bs=3D16k count=3D1 oflag=3Ddirect
3. detach and trigger writeback
#echo b1f40ca5-37a3-4852-9abf-6abed96d71db >/sys/block/bcache0/bcache/detach

the blow text is blkparse result.
from cache blktrace blow, we can see 16k data write to cache set, and then =
flush with op FWFSM(PREFLUSH|WRITE|FUA|SYNC|META)
```
  8,160 33        1     0.000000000 222844  A   W 630609920 + 32 <- (8,167)=
 1464320
  8,167 33        2     0.000000478 222844  Q   W 630609920 + 32 [dd]
  8,167 33        3     0.000006167 222844  G   W 630609920 + 32 [dd]
  8,167 33        5     0.000011385 222844  I   W 630609920 + 32 [dd]
  8,167 33        6     0.000023890   948  D   W 630609920 + 32 [kworker/33=
:1H]
  8,167 33        7     0.000111203     0  C   W 630609920 + 32 [0]
  8,160 34        1     0.000167029 215616  A FWFSM 629153808 + 8 <- (8,167=
) 8208
  8,167 34        2     0.000167490 215616  Q FWFSM 629153808 + 8 [kworker/=
34:2]
  8,167 34        3     0.000169061 215616  G FWFSM 629153808 + 8 [kworker/=
34:2]
  8,167 34        4     0.000301308   949  D WFSM 629153808 + 8 [kworker/34=
:1H]
  8,167 34        5     0.000348832     0  C WFSM 629153808 + 8 [0]
  8,167 34        6     0.000349612     0  C WFSM 629153808 [0]
```

from backing blktrace blow, the backing device first get flush op FWS(PERFL=
USH|WRITE|SYNC) because of we stop writeback, then get W op after detach,
the 16k data was writeback to backing device, and after this, the backing d=
evice never get flush op, it means that the 16k data we write it's not safe
in backing device, even we had write with fdatasync.
```
  8,144 33        1     0.000000000 222844  Q WSM 8 + 8 [dd]
  8,144 33        2     0.000016609 222844  G WSM 8 + 8 [dd]
  8,144 33        5     0.000020710 222844  I WSM 8 + 8 [dd]
  8,144 33        6     0.000031967   948  D WSM 8 + 8 [kworker/33:1H]
  8,144 33        7     0.000152945 88631  C  WS 16 + 32 [0]
  8,144 34        1     0.000186127 215616  Q FWS [kworker/34:2]
  8,144 34        2     0.000187006 215616  G FWS [kworker/34:2]
  8,144 33        8     0.000326761     0  C WSM 8 + 8 [0]
  8,144 34        3     0.020195027     0  C  WS 16 [0]
  8,144 34        4     0.020195904     0  C FWS 16 [0]
  8,144 23        1    19.415130395 215884  Q   W 16 + 32 [kworker/23:2]
  8,144 23        2    19.415132072 215884  G   W 16 + 32 [kworker/23:2]
  8,144 23        3    19.415133134 215884  I   W 16 + 32 [kworker/23:2]
  8,144 23        4    19.415137776  1215  D   W 16 + 32 [kworker/23:1H]
  8,144 23        5    19.416607260     0  C   W 16 + 32 [0]
  8,144 24        1    19.416640754 222593  Q WSM 8 + 8 [bcache_writebac]
  8,144 24        2    19.416642698 222593  G WSM 8 + 8 [bcache_writebac]
  8,144 24        3    19.416643505 222593  I WSM 8 + 8 [bcache_writebac]
  8,144 24        4    19.416650589  1107  D WSM 8 + 8 [kworker/24:1H]
  8,144 24        5    19.416865258     0  C WSM 8 + 8 [0]
  8,144 24        6    19.416871350 221889  Q WSM 8 + 8 [kworker/24:1]
  8,144 24        7    19.416872201 221889  G WSM 8 + 8 [kworker/24:1]
  8,144 24        8    19.416872542 221889  I WSM 8 + 8 [kworker/24:1]
  8,144 24        9    19.416875458  1107  D WSM 8 + 8 [kworker/24:1H]
  8,144 24       10    19.417076935     0  C WSM 8 + 8 [0]
```
>=20
> > Signed-off-by: kungf <wings.wyang@gmail.com>
> > ---
> >  drivers/md/bcache/writeback.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writebac=
k.c
> > index 4a40f9eadeaf..e5cecb60569e 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -357,7 +357,7 @@ static void write_dirty(struct closure *cl)
> >  	 */
> >  	if (KEY_DIRTY(&w->key)) {
> >  		dirty_init(w);
> > -		bio_set_op_attrs(&io->bio, REQ_OP_WRITE, 0);
> > +		bio_set_op_attrs(&io->bio, REQ_OP_WRITE | REQ_FUA, 0);
> >  		io->bio.bi_iter.bi_sector =3D KEY_START(&w->key);
> >  		bio_set_dev(&io->bio, io->dc->bdev);
> >  		io->bio.bi_end_io	=3D dirty_endio;
> >=20
>=20
--=20
kungf <wings.wyang@gmail.com>
