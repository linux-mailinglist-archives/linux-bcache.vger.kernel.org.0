Return-Path: <linux-bcache+bounces-293-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA27487E3A1
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Mar 2024 07:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18E19B20E76
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Mar 2024 06:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B54321101;
	Mon, 18 Mar 2024 06:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zvj8p7NW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6FE22616
	for <linux-bcache@vger.kernel.org>; Mon, 18 Mar 2024 06:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710742606; cv=none; b=B3WvYCShkGhR4Sbx911yB5iCpKFSFAp8RpqzbWlmxZXivWQF2ZI30wD0DB6+NIvTCvY9Ly7hgM0fFauRIzq8LEvwrxkROfNerhAcu2X6+dJb5XRo37UfYqiG7XhaBEymEYc6xr/HwJBoaJtB5e5aK5TcGknFes/nTMGDmdyVmjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710742606; c=relaxed/simple;
	bh=QPcxTX7ziPMrx+3k5+oVXDfAefrEsNmgWv6DunQjgpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a71fGQz79h93FjYytCBbFCPs2nRSO3P/Zf3c7gunaj1KjfLbBB5yuIhwOXs0W14Xa3PSoG2cCuKcGEzag6IzlXXi281uf1WEFMfkMNbMcztLa/WSzM9oFnyltpWfIhDmA2V3yqpxndX9etFWsVriod5GUe4i2Da/v3x78edL1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zvj8p7NW; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-568d160155aso4423a12.1
        for <linux-bcache@vger.kernel.org>; Sun, 17 Mar 2024 23:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710742603; x=1711347403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6b/rEMfgDnk+ZLvJP0z250HCAbjIkyzBbMGVUYaZYY0=;
        b=zvj8p7NWgapzSBqGwbvxzIPrvhb/ca/HcdNRQWz26Jic0Cort1qtCQAmXLUPFRl+CP
         QVuUaHBSKDlXp21E/IRa06bwySQZ3E7oR7XRYvzWvpBtQ+0mVMR5bEI7u07FuElMvWKF
         G0nt3RvJiv9R/T07UeTT+AcGntIUULkFcQ6razJz8+CIom6faJcsEQepSZBPmd0rY2uJ
         lAb+4ejbH4kTfV6A25+iGxsZWUGr8VWrAJ7300LUbDmtYMz5e7QBf2Eb4HjRU1LK3m7I
         +/+suZGQG5ImV2P8Kq7+bGwarQWdpaeLQAcnig8zs+lGvOsQDa/3ASD1FXSq6sgbsQfj
         3Yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710742603; x=1711347403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6b/rEMfgDnk+ZLvJP0z250HCAbjIkyzBbMGVUYaZYY0=;
        b=eH80btAv7tIHkhqH38QAXvXUELMEE59UayXkj9HuKErBxVAef6ppmQuChNcyxV9rtf
         tp16IDkY8uDN7Gla53N51Qv8+935G4ZZEA/YOs1NZO9gD3zCC28escnJVYnJpiI5b2SA
         OiOuXBoKMc+/NTKo+MjrJqyDoK0g87Y6x4y7Sc4jkH5B3GHpvne6jBkpVwAAoha9HuCT
         KwxrmCaIWbO9a7SoC9ADPlFzN1wjGmWmv/Hzs4dUu4f16LQdDk/elDQSgpFel6xvQQvI
         6GAxmZSz1s741YL8XM1PA77hR/WIX4wBWintSvwApIeMCevujLV0i+zMNIbW7nT1exeB
         5/eg==
X-Forwarded-Encrypted: i=1; AJvYcCWnbILRRBzvOLWKWyu9BjBwgbX/2GzxtlTf++z6+rB9HWTPhFT2efZVZPP1kbN8iGHByr5nRzlHck8ENOxGqQ51DwTMnhGlGRefv/wa
X-Gm-Message-State: AOJu0YynMpG3O7iHkJMK1+VfWfo0fLGrLBq3R4cqfAXqHYZV/VNeNPlT
	y2qrH58tdQpVaEkQXaDiBFevDhwLUvlNB09FD2wdWAO0iuHgIN1FcRe1srtMyyTgUaOw2xO1BZ7
	+WEoClHT1GmFghlle0oA0l1juF4E0vtNrBfrYQZGaQ4eT3w1IpXTDODs=
X-Google-Smtp-Source: AGHT+IFymnfC6bblaSbpnF30XrEOvSwqtWZiwKz26+3JU6/SuVEcyAbqZLPRbq/nJmNgEj7oVSrZVUuP1XHQmvzARDk=
X-Received: by 2002:aa7:c1c9:0:b0:568:cef7:fe5e with SMTP id
 d9-20020aa7c1c9000000b00568cef7fe5emr110952edp.6.1710742602467; Sun, 17 Mar
 2024 23:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de> <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
In-Reply-To: <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Sun, 17 Mar 2024 23:16:29 -0700
Message-ID: <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

Thank you for confirming. It looks like the 6.9 merge window just
opened last week so we hope it can catch it. Please update in this
thread when it gets submitted.

https://lore.kernel.org/lkml/CAHk-=3Dwiehc0DfPtL6fC2=3DbFuyzkTnuiuYSQrr6JTQ=
xQao6pq1Q@mail.gmail.com/T/

BTW, speaking of testing, mind if you point us to the bcache test
suite? We would like to have a look and maybe give it a try also.

Thanks
Robert

On Sun, Mar 17, 2024 at 7:00=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2024=E5=B9=B43=E6=9C=8817=E6=97=A5 13:41=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly
> >
>
> Hi Robert,
>
> > Thank you for looking into this issue.
> >
> > We tested this patch in 5 machines with local SSD size ranging from
> > 375 GB to 9 TB, and ran tests for 10 to 12 hours each. We observed no
> > stall nor other issues. Performance was comparable before and after
> > the patch. Hope this info will be helpful.
>
> Thanks for the information.
>
> Also I was told this patch has been deployed and shipped for 1+ year in e=
asystack products, works well.
>
> The above information makes me feel confident for this patch. I will subm=
it it in next merge window if some ultra testing loop passes.
>
> Coly Li
>
>
> >
> >
> > On Fri, Mar 15, 2024 at 7:49=E2=80=AFPM Coly Li <colyli@suse.de> wrote:
> >>
> >> Hi Robert,
> >>
> >> Thanks for your email.
> >>
> >>> 2024=E5=B9=B43=E6=9C=8816=E6=97=A5 06:45=EF=BC=8CRobert Pang <robertp=
ang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> Hi all
> >>>
> >>> We found this patch via google.
> >>>
> >>> We have a setup that uses bcache to cache a network attached storage =
in a local SSD drive. Under heavy traffic, IO on the cached device stalls e=
very hour or so for tens of seconds. When we track the latency with "fio" u=
tility continuously, we can see the max IO latency shoots up when stall hap=
pens,
> >>>
> >>> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar=
 15 21:14:18 2024
> >>> read: IOPS=3D62.3k, BW=3D486MiB/s (510MB/s)(11.4GiB/24000msec)
> >>>   slat (nsec): min=3D1377, max=3D98964, avg=3D4567.31, stdev=3D1330.6=
9
> >>>   clat (nsec): min=3D367, max=3D43682, avg=3D429.77, stdev=3D234.70
> >>>    lat (nsec): min=3D1866, max=3D105301, avg=3D5068.60, stdev=3D1383.=
14
> >>>   clat percentiles (nsec):
> >>>    |  1.00th=3D[  386],  5.00th=3D[  406], 10.00th=3D[  406], 20.00th=
=3D[  410],
> >>>    | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  414], 60.00th=
=3D[  418],
> >>>    | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00th=
=3D[  462],
> >>>    | 99.00th=3D[  652], 99.50th=3D[  708], 99.90th=3D[ 3088], 99.95th=
=3D[ 5600],
> >>>    | 99.99th=3D[11328]
> >>>  bw (  KiB/s): min=3D318192, max=3D627591, per=3D99.97%, avg=3D497939=
.04, stdev=3D81923.63, samples=3D47
> >>>  iops        : min=3D39774, max=3D78448, avg=3D62242.15, stdev=3D1024=
0.39, samples=3D47
> >>> ...
> >>>
> >>> <IO stall>
> >>>
> >>> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri Mar=
 15 21:21:23 2024
> >>> read: IOPS=3D26.0k, BW=3D203MiB/s (213MB/s)(89.1GiB/448867msec)
> >>>   slat (nsec): min=3D958, max=3D40745M, avg=3D15596.66, stdev=3D13650=
543.09
> >>>   clat (nsec): min=3D364, max=3D104599, avg=3D435.81, stdev=3D302.81
> >>>    lat (nsec): min=3D1416, max=3D40745M, avg=3D16104.06, stdev=3D1365=
0546.77
> >>>   clat percentiles (nsec):
> >>>    |  1.00th=3D[  378],  5.00th=3D[  390], 10.00th=3D[  406], 20.00th=
=3D[  410],
> >>>    | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  418], 60.00th=
=3D[  418],
> >>>    | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00th=
=3D[  494],
> >>>    | 99.00th=3D[  772], 99.50th=3D[  916], 99.90th=3D[ 3856], 99.95th=
=3D[ 5920],
> >>>    | 99.99th=3D[10816]
> >>>  bw (  KiB/s): min=3D    1, max=3D627591, per=3D100.00%, avg=3D244393=
.77, stdev=3D103534.74, samples=3D765
> >>>  iops        : min=3D    0, max=3D78448, avg=3D30549.06, stdev=3D1294=
1.82, samples=3D765
> >>>
> >>> When we track per-second max latency in fio, we see something like th=
is:
> >>>
> >>> <time-ms>,<max-latency-ns>,,,
> >>> ...
> >>> 777000, 5155548, 0, 0, 0
> >>> 778000, 105551, 1, 0, 0
> >>> 802615, 24276019570, 0, 0, 0
> >>> 802615, 82134, 1, 0, 0
> >>> 804000, 9944554, 0, 0, 0
> >>> 805000, 7424638, 1, 0, 0
> >>>
> >>> fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dliba=
io --name=3Dlatency_test --filename=3Dfio --bs=3D8k --iodepth=3D1 --size=3D=
900G  --readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_log=3D=
lat --log_avg_msec=3D1000 --log_max_value=3D1
> >>>
> >>> We saw a smiliar issue reported in https://www.spinics.net/lists/linu=
x-bcache/msg09578.html, which suggests an issue in garbage collection. When=
 we trigger GC manually via "echo 1 > /sys/fs/bcache/a356bdb0-...-64f794387=
488/internal/trigger_gc", the stall is always reproduced. That thread point=
s to this patch (https://www.spinics.net/lists/linux-bcache/msg08870.html) =
that we tested and the stall no longer happens.
> >>>
> >>> AFAIK, this patch marks buckets reclaimable at the beginning of GC to=
 unblock the allocator so it does not need to wait for GC to finish. This p=
eriodic stall is a serious issue. Can the community look at this issue and =
this patch if possible?
> >>>
> >>
> >> Could you please share more performance information of this patch? And=
 how many nodes/how long time does the test cover so far?
> >>
> >> Last time I test the patch, it looked fine. But I was not confident ho=
w large scale and how long time this patch was tested. If you may provide m=
ore testing information, it will be helpful.
> >>
> >>
> >> Coly Li
> >
>

