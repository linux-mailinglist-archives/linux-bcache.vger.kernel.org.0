Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464CC447A31
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Nov 2021 06:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhKHFlO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Nov 2021 00:41:14 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45628
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhKHFlN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Nov 2021 00:41:13 -0500
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 00C793F19D
        for <linux-bcache@vger.kernel.org>; Mon,  8 Nov 2021 05:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1636349909;
        bh=qszDb7BDPr+JFrk7ndzymufgUokEd+bo/5mqpRZkDgc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=VxD0J0O37BC6b3NLp8cv80K7iRhpE5ZGsadEEwbjDicDlWEqoc5MTiOK+Ok4HNuVn
         1r2flzr//WGg/JtEpD/fg+UzID6MihLSWLArL7NYgwb8A7NT6oCvRiApkfKlUALO7Z
         Mlp0/R1Ney2gK3jsfdYgeCE+1QUAgpqImjGfu6ZFYiRVGKskabqz3HA2tAvo19WreI
         g+d2B9JOu/tmD9geG5gSCD0sm03r9k+UkPAklwYp66MxamDtvWZmRMnszAj2pfjSLy
         WkNMp1MNYhKE8eYNu8EoAsrXbgcblTEWOhDtb72QVsWdQS9QpjrPAbAnl5hMWR8vBu
         9qQUYlltUlbaQ==
Received: by mail-oo1-f70.google.com with SMTP id n19-20020a4a0c53000000b002c2729494aaso964999ooe.22
        for <linux-bcache@vger.kernel.org>; Sun, 07 Nov 2021 21:38:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qszDb7BDPr+JFrk7ndzymufgUokEd+bo/5mqpRZkDgc=;
        b=RE+h785F0BpsWZXZWtzU97lPLTNh8zCEOpMKy8y/KG50Gqjo4S5QNEJP9eQnSS2nSH
         NXtimFzPmJXfvmBtYZYHdH2P6X2+AdIfPRaOrHcdcTBhNGvI7BjORDRUkpgBs6WhdvV3
         HHoKLrZw2IQ4lnaM7tOdcoSYBuAD2D9f1rCZ2YD6mHN3B5t6rb27HObooi4xZu5zE3Nj
         YugOwfub8+Xv7c8zBJZnrbnmW/Wl6uqRm3+RNk5+J5acwpfJkoEcftC9hXXbmJ8kdIkL
         nAtbFYZ1UbhiOIHHXtqHVeYjaTN2aSUbqbLivJ7TZFVyUUTh/wGnZYO2Dt7cNUt2SNoX
         IpKA==
X-Gm-Message-State: AOAM532zOAjnqicgfPhj1nPcmL3VzbR8+ejxTR0w0f0533IWd8I9MLLy
        htSd4QX9EkCp7bSS4+OWkShXXTEDi8rbgGedGQBNAijnRMucEUXWnv771MkLWQKDD4DQesP3Xjg
        eT0t+El6uMLVv11uqim8vgXk5sep4gGqlEDU4hErbrQcGC7N4fhTc/gosIg==
X-Received: by 2002:a4a:950e:: with SMTP id m14mr17737100ooi.98.1636349906603;
        Sun, 07 Nov 2021 21:38:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy09Hjs3JvOYYoBsp/1STzaf57vSA9M/l8qlxdS14GL/1HMtBq9GID3e81ZiXQXk7bxGTaHH2nlh4ht2eDoDl8=
X-Received: by 2002:a4a:950e:: with SMTP id m14mr17737053ooi.98.1636349905536;
 Sun, 07 Nov 2021 21:38:25 -0800 (PST)
MIME-Version: 1.0
References: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net>
In-Reply-To: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net>
From:   Dongdong Tao <dongdong.tao@canonical.com>
Date:   Mon, 8 Nov 2021 13:38:14 +0800
Message-ID: <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
Subject: Re: A lot of flush requests to the backing device
To:     Aleksei Zakharov <zakharov.a.g@yandex.ru>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

[Sorry for the Spam detection ... ]

Hi Aleksei,

This is a very interesting finding, I understand that ceph blustore
will issue fdatasync requests when it tries to flush data or metadata
(via bluefs) to the OSD device. But I'm surprised to see so much
pressure it can bring to the backing device.
May I know how do you measure the number of flush requests to the
backing device per second that is sent from the bcache with the
REQ_PREFLUSH flag?  (ftrace to some bcache tracepoint ?)

My understanding is that the bcache doesn't need to wait for the flush
requests to be completed from the backing device in order to finish
the write request, since it used a new bio "flush" for the backing
device.
So I don't think this will increase the fdatasync latency as long as
the write can be performed in a writeback mode.  It does increase the
read latency if the read io missed the cache.
Or maybe I am missing something, let me know how did you observe the
latency increasing from bcache layer , I would want to do some
experiments as well?

Regards,
Dongdong


On Fri, Nov 5, 2021 at 7:21 PM Aleksei Zakharov <zakharov.a.g@yandex.ru> wr=
ote:
>
> Hi all,
>
> I've used bcache a lot for the last three years, mostly in writeback mode=
 with ceph, and I faced a strange behavior. When there's a heavy write load=
 on the bcache device with a lot of fsync()/fdatasync() requests, the bcach=
e device issues a lot of flush requests to the backing device. If the write=
back rate is low, then there might be hundreds of flush requests per second=
 issued to the backing device.
>
> If the writeback rate growths, then latency of the flush requests increas=
es. And latency of the bcache device increases as a result and the applicat=
ion experiences higher disk latency. So, this behavior of bcache slows the =
application in it's I/O requests when writeback rate becomes high.
>
> This workload pattern with a lot of fsync()/fdatasync() requests is a com=
mon for a latency-sensitive applications. And it seems that this bcache beh=
avior slows down this type of workloads.
>
> As I understand, if a write request with REQ_PREFLUSH is issued to bcache=
 device, then bcache issues new empty write request with REQ_PREFLUSH to th=
e backing device. What is the purpose of this behavior? It looks like it mi=
ght be eliminated for the better performance.
>
> --
> Regards,
> Aleksei Zakharov
> alexzzz.ru
