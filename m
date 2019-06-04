Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91C034EAE
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 19:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFDRYX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 13:24:23 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51487 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfFDRYX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 13:24:23 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so1430468itl.1;
        Tue, 04 Jun 2019 10:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=684y/cl2KzqACBNQ2Tlq591/W/YeCegwH8Huw8QPTB0=;
        b=LwWQdxbcBykG9LpWPT0qPZT++cUOiQdv8QAiWFA92ZubIEDsixsI9tNrDl/orTP6Zo
         vd67ZnkmzjC7HuS+T+S3TlGlUVBUkJJWOv7XVf0K9C4sKNS2/B10CpXjKo9Y5nTt4hrk
         M20k9uTsQvYXMlZKnCjSP9PMH7xUQkxm0k5XYOQYJzOtNS5p2PjgJM302Q/DIS/tYPgc
         JkdO/oTTxqoK0DtVUqbKSDzqedKF0ZODCnXeI5TSqYMPUrHkUTD/SXmlUdOGAEAuST4R
         KJcexxAP9J7VHepSTz/zRNtlNAJ2QgPAROaN8nxeEig54LaOIM/lpvFXIQoP5ieWydMO
         1cHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=684y/cl2KzqACBNQ2Tlq591/W/YeCegwH8Huw8QPTB0=;
        b=j7dNHg/MgQ0eXm4kesdjbXDWBj6JKO58DS/tCaMd5wDMSW3vxNot70aekDnlZDz3//
         R6HJK5jpiHlAKpdzagBA0cusd9LEwDlNMMjm0PgU7uXNbIZOQr703eDD5/P7GmVG+9si
         R34JezF6Lcsm5+CDiCtH7eQCwY6ln54IaSo7Ore44BPjfAc9+OupMLUFuZYc8S+r1OPy
         BFkOcuu/4SXHaRvPGPGsWJ6NjFN6IrwltTPBKWI8xQTrAA9q357Se66UOiBF4AqiuugJ
         mnf8ysRawmDsZz5LZdbxkN8zzUylVfiwpvPs+eZ02mZi0bRC4a3e/ohr2FwaQ3ctVuvn
         meSw==
X-Gm-Message-State: APjAAAXWBddGiBf3658vdfprgCeVckvPVOuAndNMrWdDLN5G32kUEzin
        P0ngdciAzUKj7AJiKooLhX2Jeqh+AEHzyi79Zg==
X-Google-Smtp-Source: APXvYqwy06rCoqbgvSvyZBt+6AqZ+XpW5YBWeva8u+pBMISO20GpbS1CivwRYDmiyNCg/XpGMt8dCWr6az/GtH+Y9zs=
X-Received: by 2002:a24:5301:: with SMTP id n1mr21181845itb.10.1559669062380;
 Tue, 04 Jun 2019 10:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
 <6823d3ab-5f93-da74-0dbc-19bdb7be6907@suse.de> <3399cad5-4387-dd23-77f1-a70e551fb531@suse.de>
In-Reply-To: <3399cad5-4387-dd23-77f1-a70e551fb531@suse.de>
From:   =?UTF-8?Q?Bj=C3=B8rn_Forsman?= <bjorn.forsman@gmail.com>
Date:   Tue, 4 Jun 2019 19:24:10 +0200
Message-ID: <CAEYzJUE0SuO3uHm1TTxfr1kPtLic1ggUPnGFYTSPcwk6nfq82g@mail.gmail.com>
Subject: Re: bcache: oops when writing to writeback_percent without a cache device
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 4 Jun 2019 at 17:41, Coly Li <colyli@suse.de> wrote:
>
> On 2019/6/4 10:59 =E4=B8=8B=E5=8D=88, Coly Li wrote:
> > On 2019/6/4 7:00 =E4=B8=8B=E5=8D=88, Bj=C3=B8rn Forsman wrote:
> >> Hi all,
> >>
> >> I get a kernel oops from bcache when writing to
> >> /sys/block/bcache0/bcache/writeback_percent and there is no attached
> >> cache device. See the oops itself below my signature.
> >>
> >> This is on Linux 4.19.46. I looked in git and see many commits to
> >> bcache lately, but none seem to address this particular issue.
> >>
> >> Background: I'm writing to .../writeback_percent with
> >> systemd-tmpfiles. I'd rather not replace it with a script that figures
> >> out whether or not the kernel will oops if writing to the sysfs file
> >> -- the kernel should not oops in the first place.
> >
> > Hi Bjorn,
> >
> > Thank you for the reporting. I believe this is a case we missed in
> > testings. When a bcache device is not attached, it does not make sense
> > to update the writeback rate in period by the changing of writeback_per=
cent.
> >
> > I will post a patch for your testing soon.
>
> Hi Bjorn,
>
> Could you please to try this patch ? Hope it may help a bit.

Hi Coly,

Thanks for the quick patch! I tested it on linux 5.2-rc2 and it indeed
fixes the problem.

There is one typo in the patch/commit message: s/writebac/writeback/

--=20
Best regards,
Bj=C3=B8rn Forsman
