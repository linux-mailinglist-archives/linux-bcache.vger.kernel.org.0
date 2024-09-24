Return-Path: <linux-bcache+bounces-734-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A9E9849BB
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2024 18:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9162D1C22F3D
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2024 16:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182FE1AB6D3;
	Tue, 24 Sep 2024 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zj88v0t1"
X-Original-To: linux-bcache@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F711A4F22;
	Tue, 24 Sep 2024 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727195738; cv=none; b=HknWXG4eDwe1vs2arivJMImLOmCuYYDeowqhI/R0P/zHCfMqgiVRo111cooYKGKLmjVOovxj/1bInHFjUQjqjK2R13KF5pA34gyB9uJEaG32A31QG6KKJX/eBZv+cSi1dXp8naWov5rTeAT9HOoaxxwXBfMQTra79B596hKsYR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727195738; c=relaxed/simple;
	bh=Lqr9ttKdTWKFzSzmRe08yrAUPtUn/VpHz6sP7K7/I7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZF2wwPdNyjqccWMDbZQJ7feghKU/JZQE8K3hdrRXxuktb/NIpc4Wci9P2KazCDp0W8yLRs8DPjjS9E6Fkqda67wmtncHhCCMpZXhFkLttc92FCdy7MaeAZwWpZWw/yOhK+l9QcmjniQs67CW8FXvJXGX3qX69Ux4NVqbp3tiBfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zj88v0t1; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Wh1jAzeffZYy009nI33+/VcSQcTAyr6o4mJKc/jsMzk=; b=Zj88v0t1MY08AC1fTc/e1M+d67
	0X+U4pGIrLH13AWv4CZQ39nUVuYW2aHHa+eIIePpw1hOmKPxjq6S68fzMe1HgZa1Un3GOjXALczmh
	nz8KrbXP0IwG0LwcPjLCnVO628IgSgIIJ6DUbdPS/13i7cS+sUv/aXHEPVeZjtSLgjEWBXPKbb1Zo
	N/8UlA1tme5VRGmt5FZ+DCRmOOuRhLzy/doIAqh848NvNjm/Y0zHJDl15W2LpPAL/wDrJJ2MJkKKR
	tM5tFNfHqwPoa+NLI8JrAOfBlr5Dr1DiGmINErkgWPaM8freDCpJSI36yGk0oueuRX5U7zjE7NfzX
	q0RS5uNw==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1st8VW-00000001reU-3Eva;
	Tue, 24 Sep 2024 16:35:23 +0000
Message-ID: <27bf8cff-83b6-4a41-923a-7713a847f979@infradead.org>
Date: Tue, 24 Sep 2024 09:35:18 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] block: Init for CBD(CXL Block Device) module
To: Dongsheng Yang <dongsheng.yang@linux.dev>, axboe@kernel.dk,
 dan.j.williams@intel.com, gregory.price@memverge.com, John@groves.net,
 Jonathan.Cameron@Huawei.com, bbhushan2@marvell.com, chaitanyak@nvidia.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-bcache@vger.kernel.org
References: <20240918101821.681118-1-dongsheng.yang@linux.dev>
 <20240918101821.681118-9-dongsheng.yang@linux.dev>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240918101821.681118-9-dongsheng.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi.

On 9/18/24 3:18 AM, Dongsheng Yang wrote:
> diff --git a/drivers/block/cbd/Kconfig b/drivers/block/cbd/Kconfig
> new file mode 100644
> index 000000000000..16ffcca058c5
> --- /dev/null
> +++ b/drivers/block/cbd/Kconfig
> @@ -0,0 +1,45 @@
> +config BLK_DEV_CBD
> +	tristate "CXL Block Device (Experimental)"
> +	depends on DEV_DAX && FS_DAX
> +	help
> +	  CBD allows you to register a persistent memory device as a CBD transport.
> +	  You can use this persistent memory as a data cache to improve your block
> +	  device performance. Additionally, if you enable CBD_MULTIHOST, cbd allows

s/cbd/CBD/ for consistency. Or does 'cbd' here explicitly refer to the loadable module
name?

> +	  you to access block devices on a remote host as if they were local disks.
> +
> +	  Select 'y' to build this module directly into the kernel.
> +	  Select 'm' to build this module as a loadable kernel module.
  +	  The module will be called cbd.

> +
> +	  If unsure say 'N'.
> +
> +config CBD_CRC
> +	bool "Enable CBD checksum"
> +	default N

We usually omit 'default N' since that is the default default.

> +	depends on BLK_DEV_CBD
> +	help
> +	  When CBD_CRC is enabled, all data sent by CBD will include
> +	  a checksum. This includes a data checksum, a submit entry checksum,
> +	  and a completion entry checksum. This ensures the integrity of the
> +	  data transmitted through the CXL memory device.
> +
> +config CBD_DEBUG
> +	bool "Enable CBD debug"
> +	default N

Ditto.

> +	depends on BLK_DEV_CBD
> +	help
> +	  When CBD_DEBUG is enabled, cbd module will print more messages
> +	  for debugging. But that will affact performance, so do not use it

	                               affect

> +	  in production case.
> +
> +config CBD_MULTIHOST
> +	bool "multi-hosts CXL Dlock Device"

	                      Block

> +	default N

drop default line.

> +	depends on BLK_DEV_CBD
> +	help
> +	  When CBD_MULTIHOST is enabled, cbd allows the use of a shared memory device

cbd or CBD?

> +	  as a cbd transport. In this mode, the blkdev and backends on different

ditto.

> +	  hosts can be connected through the shared memory device, enabling cross-node
> +	  disk access.
> +
> +	  IMPORTANT: This Require your shared memory device support Hardware-consistency

	                  requires                          supports

> +	  as CXL 3.0 described.

	  as described in CXL 3.0.


