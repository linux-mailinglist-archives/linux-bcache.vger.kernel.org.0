Return-Path: <linux-bcache+bounces-1301-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D41C959A6
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 03:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 67DDB3410A0
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 02:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57001DE8BE;
	Mon,  1 Dec 2025 02:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMU8ccvF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64FA2032D
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 02:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764556906; cv=none; b=mrO1PtZ7HY2GAL7atCKjSlkg+wWMLbv+MI4Zt7o8yV3Rr/oKOUMuw+2Iu7ylPlIllk7Mh+UcKMDrJ13Fh8w312DpGn8ttWU8nGet7M1I3mxTCLr0fcvVTCgq03eoWwXB1YZ2/unfvhSsQY799C6qoxfmngOchByjpQEN3s6lWD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764556906; c=relaxed/simple;
	bh=bVTMBZipQSey4Fgvkem7K+oGHQCM1N5D+geGZc1LQG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFzVwVrY0pMVH+YKCfo9clP/FsytAyTZkYTSWk98Mz3GYJIknOjZTdLnRk7kK2nABGxvLJm3bde3lKjS3th98+OsMaFX7IHWnv/sxs4NaGwbaGxRqdqK4BCZN7uW9dUYgQ0xAIku8YjDSukcWNTSjykD7uiwTPZFXvKbjvl8Kww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMU8ccvF; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso46682671cf.0
        for <linux-bcache@vger.kernel.org>; Sun, 30 Nov 2025 18:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764556904; x=1765161704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4ueRZDGEmZN3pKdDV+VUbfm/GEWq1+GkEBdKVjZOtc=;
        b=HMU8ccvFVJ+OWkPxTVDXXZ6/nVErhPiyzCUNotBWsByIDtbO/TuA0uGn6ReZxP4REe
         v9GHH6zsGJFhNIYb/mVB8VRkwIZi6ZVfu4pjyBZMER8ccKdNOtAxHHlIQdfF6odjWErl
         hWwbr++SWpIOCVcI3tNEhwYqICh8V26iezv8dshZBjwp26C2WXWK1udu1hTwYwbg5fNQ
         KJJE16qROMWMY7Krr0zgBXe3RX2VKnOlY5mhYFfq4XOh702JA7ZuPawaQx1Gd98yCvNv
         nF5vuUVPNA7SzGvpKDNbvta2gMfbkVI7e/dSXDHnRL0/4LCUI1Mv7TCccGj1Puu72hMw
         sYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764556904; x=1765161704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z4ueRZDGEmZN3pKdDV+VUbfm/GEWq1+GkEBdKVjZOtc=;
        b=CuaOdrpLoLlZWD2WDI28WBdXPaMuoH4aHM2/AxSHnvINEkKNY/zr0+4ED6RlC/1YWF
         jal8yj6AmvTR8La3J3jz8UUeObfKWnvHklPFeX+enL4f+lIVJVsiNVfjbBIn7gyn2JBJ
         pLaETUCNWSY0R5AM6f4TOe+Efl1kuVRlLFWrME5SAjYAblEbQjwTM6xCUo1CsmErwUyH
         riIPr7+NS9zWk/fKYfO+HP/WD4AQ/p18b3A8Ghl1+pGlUg+Yy9ZrWZtK4CtbnWo6RDvC
         +rMw/ISH9PK5kNs+1VKS8sjyFyaKAe8BwFFWNM540eFpFHMQcndLV/ySjvZWtfdryIHz
         236A==
X-Forwarded-Encrypted: i=1; AJvYcCXTk2spzsCuG/CLZn3G5fHAVBgPWfUSQ7fVHZCebvaSzGReZV0I8qAFirz+u688FKUZxIsZ1XVGbFMELYM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/1CT3yPgkw/JOFJLc9WygHvVPuHg6JdpItbteLUyeOAFmcWHn
	Bv5FxvUcCajUtTALQQCCKk3hNqP97QXOi94fhuKypfzc1/cua54A5qtEgTnMLX/OJFuwNrP3W8R
	fkDmlXQt3pYuFkfrj+qclPLeIhPctYvA=
X-Gm-Gg: ASbGnctLQ+KgAvbqOKvdr+wPZO2JJAaIdFKgaeXZkyiQtP4+hQXMk6+k61cHZMw/mNN
	PhG9BV4fjqknE52jOY59SkXxtd24T3Iamq3tSxBxqYv17ikP+MFZIHQ4rW8fNyLkftTmSRywHPn
	jczOhIqUmt27rG7U5lota0EARdchIj7E5ohWAqeMvw/mFeqQ0LYfqdUYOaGD3LEC5Qqz3adkNVL
	As2zW2Rn07KJRk//w3mNrvV/wX4nCWICCZtnOmZnNfuYxT9x/VX//ItpxaFci2foo+tJFs=
X-Google-Smtp-Source: AGHT+IEmvBJytrUYv3PRff54NTqLEiIVWOTOdu8c+jgIKKnb+TW+2xLZqLXPCQhWGcR80rf7EC5pZtRoolK6Jl03Lrg=
X-Received: by 2002:a05:622a:14ce:b0:4ee:ce1:ed8a with SMTP id
 d75a77b69052e-4efbd91573emr353928791cf.16.1764556903722; Sun, 30 Nov 2025
 18:41:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-13-zhangshida@kylinos.cn> <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
In-Reply-To: <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 1 Dec 2025 10:41:06 +0800
X-Gm-Features: AWmQ_blj_C1mdvu7tNb0hVlGGZGM9DWXbWPpg6J4BwD_02XuZ0ipoM_caXqdy_E
Message-ID: <CANubcdWAk2Mh5b9stjTh8N84jq+XAgaR3n2-VYRinU9ERtJLUw@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn, Andreas Gruenbacher <agruenba@redhat.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sagi Grimberg <sagi@grimberg.me> =E4=BA=8E2025=E5=B9=B412=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=B8=80 07:03=E5=86=99=E9=81=93=EF=BC=9A
>
> Acked-by: Sagi Grimberg <sagi@grimberg.me>

Hello,

I already dropped this patch in v3:
https://lore.kernel.org/all/20251129090122.2457896-1-zhangshida@kylinos.cn/
The reason is that the order of operations is critical. In the original cod=
e::
----------------
...
bio->bi_end_io =3D nvmet_bio_done;

for_each_sg(req->sg, sg, req->sg_cnt, i) {
...
          struct bio *prev =3D bio;
....
          bio_chain(bio, prev);
          submit_bio(prev);
}
----------------

the oldest bio (i.e., prev) retains the real bi_end_io function:

bio -> bio -> ... -> prev
However, using bio_chain_and_submit(prev, bio) would create the reverse cha=
in:

prev -> prev -> ... -> bio

where the newest bio would hold the real bi_end_io function, which does not
match the required behavior in this context.

Thanks,
Shida

