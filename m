Return-Path: <linux-bcache+bounces-291-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0CEC87DC5E
	for <lists+linux-bcache@lfdr.de>; Sun, 17 Mar 2024 06:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90FACB20EA2
	for <lists+linux-bcache@lfdr.de>; Sun, 17 Mar 2024 05:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EF163CF;
	Sun, 17 Mar 2024 05:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tcMc4yrs"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101F4611E
	for <linux-bcache@vger.kernel.org>; Sun, 17 Mar 2024 05:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710654082; cv=none; b=BExA/B2/C3lZUE7P/4B7NoWUK+w6tD52OZV5YEtjLs7xWTTG/xZLDGGr/UbBPoLz7weoOwBuUo7n1dGHjRfWtw2oJ8G+f25XNe4nbD79fuYgaib2TeJqTVFsMmwqGqvOT1GqarHxn82M7LlfeaewubySJvAry3Dcsm+DkL+TtB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710654082; c=relaxed/simple;
	bh=VyDrw28TtZ/HOj9GueSqbvLSxZ2PomODZAYZbQw3yYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6ft7hN37foTA9MlzYjCpy5OsxoH8EXbZDHN5ce2tf+OfGOM9eBb/Wz2GWDljsXtPgVygwOn4M9sJ/zJFiXOj8rtgSWKqT6bizEIt6/rUxelssnur1eoAf+M2XUI5HTd2wEcMqDmT/AMzZM0Ghye6BoBrCOadSIhyftn355J7jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tcMc4yrs; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41400657d16so58725e9.0
        for <linux-bcache@vger.kernel.org>; Sat, 16 Mar 2024 22:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710654079; x=1711258879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QB2Ll1S7OJ0TlGELU0+qfajYo4j9ud4A9jZDJNhDOhM=;
        b=tcMc4yrsSSdm2N+bYW+ziMO0UDjlzr/zDLxwMWXdz7H6omSEL0fzLM+/Jb+8yytIXp
         Ncpa/NcqBXs0tuEolFEBUKyBYS6J6RMLTtrjxrgPll0jT7UPJRmo7hs/oAlXzB03WksH
         rqDIz021RR1gF1jpn/q/MjLUBnKxVmJKv7VylQGZ/ODrH3ybfHWa1uOEMX927A2nla63
         Y3+69m2i3PJk9FHHzlDcayVLpw1m7UXpEABUVrRUrToEXjmslJFaEQnyC9OrU2Blj/ZX
         HmH9++vZW8RihTYhntTMDOE204P0QXJdcbp3FHyZH7Z9UGzI+OYbAnzNox2j3JOSd++d
         u3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710654079; x=1711258879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QB2Ll1S7OJ0TlGELU0+qfajYo4j9ud4A9jZDJNhDOhM=;
        b=sTCXfUzIY1VUFr4br84l6DSKF5EjguV7qqwcUkYTenTNwgcr2P6IFCFqvx2IwAehb6
         E5nRtWOzTVXdHbI6o+3fkMzYqA1tldAb8pwLHA/2Rcf5KS5cr9JBoqpPySM6HKcvp5Qw
         ZYrn6MXu8BNApIiD+NrrDL0nMNqBTZDonjauRkzmWDjWDncDS8Omy1I/ZH25H/CFQmRn
         VyE3wM4rPHyQXpfYLj0lEQIkn+jaaKs6BVD5Xhtb7Xx/Y2oyNFCe08g6ApOWDhD11IiY
         UPeegViIIbG0GoaiWjOOUJTU58IlzjZSp09iWMYcDEzlgt9NHo91C/TV0T4alEx4QS/9
         FhMg==
X-Forwarded-Encrypted: i=1; AJvYcCUEvDZexSPpTt92uqFxyx/I9uZKeKVOrca00pVS3Cp2f+sIXNhEdVyidG5iNsflq5TcCmgb/BNGZDYJPNFJZwgDzJJHcJ6091+1+hXY
X-Gm-Message-State: AOJu0YzrQVPnovVEAPNjS1We8+XM7tba0cgpsI9jBfmpafiyk5cnJzTx
	cEn7teQs1OW7snPLlBcy+2RvcINdXfU06thJbb/JVSnpfZZPrce6nDcbLXPHgsDENW/MuXv8Sma
	rYAu0qrNSF4LM2QOnyIcExMi0bB4TWiTRcRxg
X-Google-Smtp-Source: AGHT+IGqocGw+knqD57maNsPVedx+HV4yew8ZBrElDmsEdj+wgWa006wxLbn1ctxaWbnAh981z5xHUMOXU1rxEPRuLQ=
X-Received: by 2002:a05:600c:c09:b0:413:f4e8:fe3a with SMTP id
 fm9-20020a05600c0c0900b00413f4e8fe3amr117060wmb.3.1710654079085; Sat, 16 Mar
 2024 22:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
In-Reply-To: <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Sat, 16 Mar 2024 22:41:06 -0700
Message-ID: <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

Thank you for looking into this issue.

We tested this patch in 5 machines with local SSD size ranging from
375 GB to 9 TB, and ran tests for 10 to 12 hours each. We observed no
stall nor other issues. Performance was comparable before and after
the patch. Hope this info will be helpful.

Yours
Robert


On Fri, Mar 15, 2024 at 7:49=E2=80=AFPM Coly Li <colyli@suse.de> wrote:
>
> Hi Robert,
>
> Thanks for your email.
>
> > 2024=E5=B9=B43=E6=9C=8816=E6=97=A5 06:45=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi all
> >
> > We found this patch via google.
> >
> > We have a setup that uses bcache to cache a network attached storage in=
 a local SSD drive. Under heavy traffic, IO on the cached device stalls eve=
ry hour or so for tens of seconds. When we track the latency with "fio" uti=
lity continuously, we can see the max IO latency shoots up when stall happe=
ns,
> >
> > latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar 1=
5 21:14:18 2024
> >  read: IOPS=3D62.3k, BW=3D486MiB/s (510MB/s)(11.4GiB/24000msec)
> >    slat (nsec): min=3D1377, max=3D98964, avg=3D4567.31, stdev=3D1330.69
> >    clat (nsec): min=3D367, max=3D43682, avg=3D429.77, stdev=3D234.70
> >     lat (nsec): min=3D1866, max=3D105301, avg=3D5068.60, stdev=3D1383.1=
4
> >    clat percentiles (nsec):
> >     |  1.00th=3D[  386],  5.00th=3D[  406], 10.00th=3D[  406], 20.00th=
=3D[  410],
> >     | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  414], 60.00th=
=3D[  418],
> >     | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00th=
=3D[  462],
> >     | 99.00th=3D[  652], 99.50th=3D[  708], 99.90th=3D[ 3088], 99.95th=
=3D[ 5600],
> >     | 99.99th=3D[11328]
> >   bw (  KiB/s): min=3D318192, max=3D627591, per=3D99.97%, avg=3D497939.=
04, stdev=3D81923.63, samples=3D47
> >   iops        : min=3D39774, max=3D78448, avg=3D62242.15, stdev=3D10240=
.39, samples=3D47
> > ...
> >
> > <IO stall>
> >
> > latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar 1=
5 21:21:23 2024
> >  read: IOPS=3D26.0k, BW=3D203MiB/s (213MB/s)(89.1GiB/448867msec)
> >    slat (nsec): min=3D958, max=3D40745M, avg=3D15596.66, stdev=3D136505=
43.09
> >    clat (nsec): min=3D364, max=3D104599, avg=3D435.81, stdev=3D302.81
> >     lat (nsec): min=3D1416, max=3D40745M, avg=3D16104.06, stdev=3D13650=
546.77
> >    clat percentiles (nsec):
> >     |  1.00th=3D[  378],  5.00th=3D[  390], 10.00th=3D[  406], 20.00th=
=3D[  410],
> >     | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  418], 60.00th=
=3D[  418],
> >     | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00th=
=3D[  494],
> >     | 99.00th=3D[  772], 99.50th=3D[  916], 99.90th=3D[ 3856], 99.95th=
=3D[ 5920],
> >     | 99.99th=3D[10816]
> >   bw (  KiB/s): min=3D    1, max=3D627591, per=3D100.00%, avg=3D244393.=
77, stdev=3D103534.74, samples=3D765
> >   iops        : min=3D    0, max=3D78448, avg=3D30549.06, stdev=3D12941=
.82, samples=3D765
> >
> > When we track per-second max latency in fio, we see something like this=
:
> >
> > <time-ms>,<max-latency-ns>,,,
> > ...
> > 777000, 5155548, 0, 0, 0
> > 778000, 105551, 1, 0, 0
> > 802615, 24276019570, 0, 0, 0
> > 802615, 82134, 1, 0, 0
> > 804000, 9944554, 0, 0, 0
> > 805000, 7424638, 1, 0, 0
> >
> > fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dlibaio=
 --name=3Dlatency_test --filename=3Dfio --bs=3D8k --iodepth=3D1 --size=3D90=
0G  --readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_log=3Dla=
t --log_avg_msec=3D1000 --log_max_value=3D1
> >
> > We saw a smiliar issue reported in https://www.spinics.net/lists/linux-=
bcache/msg09578.html, which suggests an issue in garbage collection. When w=
e trigger GC manually via "echo 1 > /sys/fs/bcache/a356bdb0-...-64f79438748=
8/internal/trigger_gc", the stall is always reproduced. That thread points =
to this patch (https://www.spinics.net/lists/linux-bcache/msg08870.html) th=
at we tested and the stall no longer happens.
> >
> > AFAIK, this patch marks buckets reclaimable at the beginning of GC to u=
nblock the allocator so it does not need to wait for GC to finish. This per=
iodic stall is a serious issue. Can the community look at this issue and th=
is patch if possible?
> >
>
> Could you please share more performance information of this patch? And ho=
w many nodes/how long time does the test cover so far?
>
> Last time I test the patch, it looked fine. But I was not confident how l=
arge scale and how long time this patch was tested. If you may provide more=
 testing information, it will be helpful.
>
>
> Coly Li

