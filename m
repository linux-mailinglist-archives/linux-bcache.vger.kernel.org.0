Return-Path: <linux-bcache+bounces-791-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5FC9D1F29
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 05:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0876C282C9D
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Nov 2024 04:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347AD13F42F;
	Tue, 19 Nov 2024 04:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKB+kUQG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988A920E6;
	Tue, 19 Nov 2024 04:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731989992; cv=none; b=uQLyAW+U27bWvLqPROJw6E/7SIPeuFRzkCBislGGQixjLKCa500xc1sF6qX0Y6IwbucG7VQ6LWXfmiNWthRJ9vQ+Oi6WE2LxRcATc5/GatzNdedaq02Ww5caChQUgg3LWXzaqacGG2ar/TnbEC/+NhT8F09R2Y8sBb71xNHOKWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731989992; c=relaxed/simple;
	bh=rSXFAETp2MZhQ8efkwaFIrsiLpbmjHZDvYQ9vnidYGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bQjiecA1c5cUZNtlzGEKneXY4twWEjZs/w4uXzVozQyL3TXMr/+IGuf0hpugSxDXTr4SgQ/6HQhwug5zeKZD4e+n/UHZp2qfeIe/PunZrEcFVDtUCdaktstqnJ8MXmhrWTAmW38ofd0g10qfi1/uIoYihWXvMjkeF5veHwgJse8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NKB+kUQG; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6d40263adbaso31347326d6.0;
        Mon, 18 Nov 2024 20:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731989989; x=1732594789; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alftURXz0Tze06p7HOwS1rcqp+gUTcrhv5QU892di2M=;
        b=NKB+kUQGUpBaCYrbRHApSQzyq6lIuqgB7rSNETqxUC0cc18tyE9a553Yfy3N/BAEV+
         RG+VFqx0+KaCkqwUN4GGBmE5ZcSblsDm8k3PVEITq+Ygch0GxIF7wAQzW5yIOKzwDs4Q
         WoHAJkiUwFYbYjcgAjiqvyKuwlipxNdFi1t8ZW37h0HeY5bTAJchGxR0HF8N1mOTQXUR
         6QVbglvAeOQ6xid+wdzb7IFGpjHCjXuM+9CInETz40+WhwBXUc1Y1nH4pt/qm5v7bqs7
         k6cuvUadoG0W95opUUcJJzRLX3ORms9GpI+I1vAxITobQngsj6fl1m9ayjhu4sHwfzP9
         2Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731989989; x=1732594789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alftURXz0Tze06p7HOwS1rcqp+gUTcrhv5QU892di2M=;
        b=BFULajzx6EXTSREjhqscFj5nu/m7bR9ugp/hPtKrAiMMf24KHaoQNUScGNHaSYOW7G
         rVSIGcxM0lAxhlHZj/IF/ybHKa3j2pyfEz5olRv5Oc0/+DfKREVRzL3d+KIGykyGzyXj
         +6Nk0f6FWzaBfLqhiSIX4E4Xp+8FUTr98lJxDIRHZkehdkjEAFMQQ/DuFKfYz+LfzMiS
         /dl8E1dMjJIG1ecRqWZctDHCtTQODqEvd0X3c7LDLrByGf4CKk0JlwmGLosqzx/wX4gv
         7ZEXygjwqlFvt7BE/7qwIeE/v4pqHZSX8ZWEiFguoBfdDA6JlawyI8H7RKSSniGLE9M6
         fWOw==
X-Forwarded-Encrypted: i=1; AJvYcCVXMIlSSE+1FBeWd8MkFEoGEswFQbxbNIgD+JLZkdnP7kfMZ+r05cOj2YAbPacyLkAYF3ybBQ+cXEtr7aE=@vger.kernel.org, AJvYcCXt74fHRIrusy9BayUK8fXIcImOOw1G+lJwoNFnu4KisVYG8QQJVoG5ZRHoh/XFac+La6deUok//2lRfkYq@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4yz2VZG0OX90QiTQZ2AcOO6lz1gWazu2FKlwqH8gdPaN+oZ5H
	FWBF1S4OA/slKOPmXDJc3oO2ae3GzLXOUhGY4EluUr3G9CAMvPvJ2VOkLJghHGn6dqjZt51KyBU
	ogp+0W1Jp8R7WfpCiObCxRPa6z/0=
X-Google-Smtp-Source: AGHT+IHa5tIBWx713nEoyMm1jHBmdBT5AfmYR6C8Wgz6RLJNGhdbT+yTvJXK2VgwALuApKg0iICbydCg/SVRWwF+Ibc=
X-Received: by 2002:a05:6214:1c08:b0:6d4:10b0:c23c with SMTP id
 6a1803df08f44-6d410b0c455mr158018776d6.9.1731989989291; Mon, 18 Nov 2024
 20:19:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de> <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
 <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de>
In-Reply-To: <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de>
From: liequan che <liequanche@gmail.com>
Date: Tue, 19 Nov 2024 12:19:38 +0800
Message-ID: <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com>
Subject: Re: [PATCH] bcache:fix oops in cache_set_flush
To: Coly Li <colyli@suse.de>
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>, Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi coly:
>>  The same operation was performed on three servers, replacing the 12T
>> disk with a 16T disk. Only one server triggered the bug. The on-site

>What do you mean =E2=80=9Creplacing 12T disk with a 16T disk=E2=80=9D ?

Use another 16T SATA disk to replace the 12T SATA disk.
Plan to use the 16T hard disk and the original nvme disk to recreate bcache=
.

>> No bcache data clearing operation was performed

>What is the =E2=80=9Cbcache data clearing operation=E2=80=9D here?
Nothing was done. But I plan to erase the superblock after
partitioning the nvme disk.
I plan to discard the original nvme disk data by erasing the
superblock and wipe-bcache options.
>> 3. Replace the 12T SATA disk with a 16T SATA disk
>> After shutting down, unplug the 12T hard disk and replace it with a
>> 16T hard disk.

>It seems you did something bcache doesn=E2=80=99t support. Replace the bac=
king device...
You are right. I may have done something that bcache does not support.
But I hope that the wrong operation will not cause the system to panic.
The consequence I can accept is that the bcache device creation fails.
The bcache module can give me a chance to erase the superblock again,
instead of entering the CD rescue mode to erase the superblock.


>> 7. Repartition again, triggering kernel panic again.
>> parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
>> The same operation was performed on the other two servers, and no
>> panic was triggered.

>I guess this is another undefine operation. I assume the cache device is s=
till references somewhere. A reboot should follow the wipefs.
Your guess is correct. In addition, after erasing the superblock
information in CD rescue mode,
I rebooted into the system where the original panic kernel was located.

>> The server with the problem was able to enter the system normally
>> after the root of the cache_set structure was determined to be empty.
>> I updated the description of the problem in the link below.

>No, if you clean up the partition, no cache device will exist. Cache regis=
tration won=E2=80=99t treat it as a bcache device.

>OK, from the above description, I see you replace the backing device (and =
I don=E2=80=99t know where the previous data was), then you extend the cach=
e device size. They are all unsupported operations.
The behavior here is a bit strange. After partitioning, I may have
recreated the bcache device here,
which triggered the bcache rigister operation. Then the kernel panicked aga=
in.
>make-bcache -C /dev/nvme2n1p1 -B /dev/sda --writeback --force --wipe-bcach=
e

Thanks.

