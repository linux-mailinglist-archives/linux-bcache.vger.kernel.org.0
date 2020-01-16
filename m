Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F0F13FBC0
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jan 2020 22:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbgAPV4M (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jan 2020 16:56:12 -0500
Received: from mail-qk1-f181.google.com ([209.85.222.181]:41651 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbgAPV4M (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jan 2020 16:56:12 -0500
Received: by mail-qk1-f181.google.com with SMTP id x129so20739392qke.8
        for <linux-bcache@vger.kernel.org>; Thu, 16 Jan 2020 13:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=jcaUPyadnORoQkvGmpQfCdsSKURhwJenTkcP8WBcQxs=;
        b=tfjQPpmE5HfqqE+2lhR50uWozQFfKbuZduBz+Ku8cObTSXmuhowjmvDtc1VDOjgZmi
         LWa/MyT2yAEvHBAqO9lLjtem6Bvrw4n7Iuyq6lKKZO6r1ziehk2aSv/D3Q4Iu9AQPo3K
         0SHOOwz0Fm2WA/yWpzZuB+PVDyu69rmQgqCkngFigP2dBritb2tXoEl5IKNwtCnE2IS2
         GfeVA2+JU6u7Cd2Qi/v87qBunKlAvhF4Lowi9xD6/N9TPLHme2vBa97GrbaPF6jetHgw
         YdLDnnDhl2vkcGy6tisrgObufPlYN9+ONjUtnoTljqIAfb3hXbQzDOKbdGyDfIPW0mGl
         WuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=jcaUPyadnORoQkvGmpQfCdsSKURhwJenTkcP8WBcQxs=;
        b=Jbpfw9H4Z9NbPc0Ox+2jRPQO/qFMiISKcEYa176NJlZjnYwFgOSILLth4dZRp82oka
         bT2XyIRYbYClAHD68AgXs3g2W6r3WWxjlpgN4u0CkPm9CdI6syBbI7Fbeo78FWpuKrTZ
         x50bKUkhZPIIqk4+kQTAqqXJqQS1DeUqlE8XmYzJWFuqDyysbn/XUPkhzDCv+El1Yebe
         pICk7ARxHvyice7XoiafwnsUA6AQYVN6a9oycvHOnIvLgLT9bo8D0S9WGRB86d0pWLoC
         nGtPu8guVLm0pddZEJrUfnGH4EhWBYkK72TxsOPJ/KxJjRXm42U3RC1uW4MB0lJWs+Be
         5dEg==
X-Gm-Message-State: APjAAAUb8CWkyqZj+K4V1OS0rA2qlGWEiwhoemPyjCXJxo93koIz2zGe
        DDdKT6Hq2gSNt96W8hXqu3dvpUsRvJ9mvkEv8g+JUEO6
X-Google-Smtp-Source: APXvYqwydcw4K9liPbvk/Wzx929TWcAXO6SRIwik5ncEsg1vrrVfD3BoXeDU8iJEn8doLRvxDX8VjHxqrOc/rHZPh58=
X-Received: by 2002:ae9:eb56:: with SMTP id b83mr34471780qkg.123.1579211771075;
 Thu, 16 Jan 2020 13:56:11 -0800 (PST)
MIME-Version: 1.0
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de> <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de> <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com> <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
In-Reply-To: <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
Reply-To: clodoaldo.pinto.neto@gmail.com
From:   Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Date:   Thu, 16 Jan 2020 18:56:00 -0300
Message-ID: <CA+Z73LGmM2YV1PkADFpQghqaNVNqAGjPg+LF8NSG9UTahcxGtg@mail.gmail.com>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing device)
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de> escreveu:
>
> On 2020/1/13 8:44 =E4=B8=8B=E5=8D=88, Jens-U. Mozdzen wrote:
> > Hi Coly,
> >
> > jumping in here, because I was looking for a way to revert from bcache
> > to plain device:
> >
> > Zitat von Coly Li <colyli@suse.de>:
> >> The super block location of the backing disk is occupied by bcache. Yo=
u
> >> cannot mount the file system directly from the backing disk which is
> >> formated as bcache backing device [...] (bcache offset all I/Os on
> >> bcache device 4KB behind the requesting
> >> LBA on backing disk).
> >
> > Assuming that no caching device is associated with a backing device (so
> > the backing device is "clean" as in "containing all data blocks with th=
e
> > current content"), could one convert the content of a backing device to
> > a "non-bcached device" by removing the first 4096 octets of the backing
> > device content?
> >
> > Something like "dd if=3Dbackingdev of=3Dnewdev skip_bytes=3D4096 ..."?
>
> Hi Jens-U,
>
> you may try dmsetup to setup a linear device mapper target, and the map
> table just skipping the first 4KB (bcache superblock area). If you are
> lucky, I mean the real file system is not corrupted, the created device
> mapper target can be mounted directly.


I'm trying dmsetup but it does not accept anything other than 0 and 0
at the beginning and end of the table:

# echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup create =
dmb
device-mapper: reload ioctl on dmb  failed: Invalid argument
Command failed.

# echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup create =
dmb
device-mapper: reload ioctl on dmb  failed: Invalid argument
Command failed.

I'm not sure about how it works. Is it not 8 sectors for 4k bytes?


Clodoaldo

>
> --
>
> Coly Li
>
